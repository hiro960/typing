#!/usr/bin/env node

/**
 * シャドーイング音声ファイル生成スクリプト
 *
 * Google Cloud Text-to-Speech API を使用して、
 * シャドーイングコンテンツの音声ファイル（MP3）を生成します。
 *
 * 使用方法:
 *   node generate-audio.js --level beginner
 *   node generate-audio.js --level intermediate
 *   node generate-audio.js --level advanced
 *   node generate-audio.js --id beginner_001
 *   node generate-audio.js --all
 *   node generate-audio.js --level beginner --with-timestamps  # タイムスタンプ取得＆JSON更新
 */

const textToSpeech = require("@google-cloud/text-to-speech");
const { program } = require("commander");
const fs = require("fs");
const path = require("path");
const util = require("util");

// ===== 設定 =====

const CONFIG = {
  // JSONファイルのパス（プロジェクトルートからの相対パス）
  jsonBasePath: "../../application/assets/shadowing",

  // 音声ファイルの出力先（プロジェクトルートからの相対パス）
  audioBasePath: "../../application/assets/audio/shadowing",

  // Google Cloud TTS の音声設定
  voice: {
    languageCode: "ko-KR",
    // Wavenet音声（高品質）
    // - ko-KR-Wavenet-A: 女性
    // - ko-KR-Wavenet-B: 男性
    // - ko-KR-Wavenet-C: 男性
    // - ko-KR-Wavenet-D: 女性
    //
    // Neural2音声（最高品質、推奨）
    // - ko-KR-Neural2-A: 女性
    // - ko-KR-Neural2-B: 女性
    // - ko-KR-Neural2-C: 男性
    name: "ko-KR-Neural2-A",
    ssmlGender: "FEMALE",
  },

  // 音声出力設定
  audioConfig: {
    audioEncoding: "MP3",
    speakingRate: 0.95, // 0.25〜4.0（1.0が標準、少し遅めに設定）
    pitch: 0.0, // -20.0〜20.0（0.0が標準）
    sampleRateHertz: 44100,
  },

  // レベル別のディレクトリ名
  levels: {
    beginner: "beginner",
    intermediate: "intermediate",
    advanced: "advanced",
  },
};

// ===== ユーティリティ関数 =====

/**
 * ディレクトリが存在しない場合は作成する
 */
function ensureDirectoryExists(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`📁 ディレクトリを作成しました: ${dirPath}`);
  }
}

/**
 * JSONファイルを読み込む
 */
function loadJsonFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, "utf-8");
    return JSON.parse(content);
  } catch (error) {
    console.error(`❌ JSONファイルの読み込みに失敗しました: ${filePath}`);
    console.error(error.message);
    return null;
  }
}

/**
 * JSONファイルを保存する
 */
function saveJsonFile(filePath, data) {
  try {
    const content = JSON.stringify(data, null, 2);
    fs.writeFileSync(filePath, content, "utf-8");
    console.log(`💾 JSONファイルを保存しました: ${filePath}`);
    return true;
  } catch (error) {
    console.error(`❌ JSONファイルの保存に失敗しました: ${filePath}`);
    console.error(error.message);
    return false;
  }
}

/**
 * IDから出力ファイルパスを生成
 * 例: beginner_001 -> beginner/001.mp3
 */
function getOutputPath(id, level) {
  const match = id.match(/^(beginner|intermediate|advanced)_(\d+)$/);
  if (!match) {
    throw new Error(`無効なID形式です: ${id}`);
  }

  const [, levelName, number] = match;
  const audioDir = path.join(__dirname, CONFIG.audioBasePath, levelName);
  ensureDirectoryExists(audioDir);

  return path.join(audioDir, `${number}.mp3`);
}

/**
 * SSMLテキストを生成（より自然な読み上げのため）
 */
function generateSSML(text) {
  // 文の区切りで適切な間を入れる
  let ssml = text
    // 文末の「。」の後に短い間を追加
    .replace(/\. /g, '.<break time="500ms"/> ')
    .replace(/。/g, '。<break time="500ms"/>')
    // 「,」の後に短い間を追加
    .replace(/, /g, ',<break time="300ms"/> ')
    .replace(/、/g, '、<break time="300ms"/>');

  return `<speak>${ssml}</speak>`;
}

/**
 * セグメントごとに<mark>タグを挿入したSSMLを生成
 * 各セグメントの開始位置にマークを挿入し、最後に終了マークを追加
 */
function generateSSMLWithMarks(segments) {
  let ssml = "<speak>";

  segments.forEach((segment, index) => {
    // セグメント開始マーク
    ssml += `<mark name="seg_${index}_start"/>`;

    // セグメントのテキスト（breakタグ付き）
    let segmentText = segment.text
      .replace(/\. /g, '.<break time="500ms"/> ')
      .replace(/。/g, '。<break time="500ms"/>')
      .replace(/, /g, ',<break time="300ms"/> ')
      .replace(/、/g, '、<break time="300ms"/>');

    ssml += segmentText;

    // セグメント終了マーク（次のセグメントの開始と同じになるが、最後のセグメント用）
    ssml += `<mark name="seg_${index}_end"/>`;
  });

  ssml += "</speak>";
  return ssml;
}

/**
 * timepointsからセグメントのstartTime/endTimeを計算
 */
function calculateSegmentTimes(timepoints, segments, totalDuration) {
  const updatedSegments = [];

  for (let i = 0; i < segments.length; i++) {
    const startMark = timepoints.find((tp) => tp.markName === `seg_${i}_start`);
    const endMark = timepoints.find((tp) => tp.markName === `seg_${i}_end`);

    const startTime = startMark ? startMark.timeSeconds : 0;
    // 終了時間は次のセグメントの開始時間、または最後のセグメントの場合は音声全体の長さ
    let endTime;
    if (endMark) {
      endTime = endMark.timeSeconds;
    } else if (i < segments.length - 1) {
      const nextStartMark = timepoints.find(
        (tp) => tp.markName === `seg_${i + 1}_start`
      );
      endTime = nextStartMark ? nextStartMark.timeSeconds : totalDuration;
    } else {
      endTime = totalDuration;
    }

    updatedSegments.push({
      ...segments[i],
      startTime: Math.round(startTime * 100) / 100, // 小数点2桁に丸める
      endTime: Math.round(endTime * 100) / 100,
    });
  }

  return updatedSegments;
}

/**
 * MP3ファイルの長さを取得（簡易的な方法）
 * より正確な方法が必要な場合は music-metadata パッケージを使用
 */
async function getAudioDuration(audioBuffer) {
  // MP3のビットレートとファイルサイズから概算
  // より正確な値が必要な場合は music-metadata パッケージを使用
  const fileSizeBytes = audioBuffer.length;
  const bitrate = 128000; // 128kbps (CONFIG.audioConfig の設定に合わせる)
  const durationSeconds = (fileSizeBytes * 8) / bitrate;
  return Math.round(durationSeconds * 100) / 100;
}

// ===== メイン処理 =====

/**
 * 音声を生成する（タイムスタンプ取得オプション付き）
 */
async function generateAudio(client, content, options = {}) {
  const { id, text, title, segments } = content;
  const { dryRun = false, force = false, withTimestamps = false } = options;

  // 出力パスを取得
  const outputPath = getOutputPath(id, content.level);

  // 既存ファイルのチェック
  if (!force && fs.existsSync(outputPath)) {
    console.log(`⏭️  スキップ（既存）: ${id} - ${title}`);
    return { id, status: "skipped", path: outputPath };
  }

  console.log(`🎙️  生成中: ${id} - ${title}`);

  if (dryRun) {
    console.log(`   テキスト: ${text.substring(0, 50)}...`);
    if (withTimestamps && segments) {
      console.log(`   セグメント数: ${segments.length}`);
    }
    return { id, status: "dry-run", path: outputPath };
  }

  try {
    let request;
    let ssml;

    if (withTimestamps && segments && segments.length > 0) {
      // タイムスタンプ取得モード: セグメントごとにmarkタグを挿入
      ssml = generateSSMLWithMarks(segments);
      request = {
        input: { ssml },
        voice: CONFIG.voice,
        audioConfig: CONFIG.audioConfig,
        enableTimePointing: [1], // 1 = SSML_MARK
      };
    } else {
      // 通常モード
      ssml = generateSSML(text);
      request = {
        input: { ssml },
        voice: CONFIG.voice,
        audioConfig: CONFIG.audioConfig,
      };
    }

    // synthesizeSpeechは[response, metadata, rawResponse]を返す
    const fullResponse = await client.synthesizeSpeech(request);

    const response = fullResponse[0];

    // ファイルに書き込み
    const writeFile = util.promisify(fs.writeFile);
    await writeFile(outputPath, response.audioContent, "binary");

    console.log(`✅ 完了: ${id} -> ${path.basename(outputPath)}`);

    // タイムスタンプ情報を返す
    let updatedSegments = null;
    if (withTimestamps && response.timepoints && response.timepoints.length > 0) {
      const totalDuration = await getAudioDuration(response.audioContent);
      updatedSegments = calculateSegmentTimes(
        response.timepoints,
        segments,
        totalDuration
      );

      console.log(`   ⏱️  タイムスタンプ取得: ${response.timepoints.length}個のマーク`);

      // セグメントごとの時間を表示
      updatedSegments.forEach((seg, i) => {
        console.log(
          `      [${i}] ${seg.startTime.toFixed(2)}s - ${seg.endTime.toFixed(2)}s: ${seg.text.substring(0, 30)}...`
        );
      });
    }

    return {
      id,
      status: "success",
      path: outputPath,
      segments: updatedSegments,
      durationSeconds: updatedSegments
        ? Math.round(updatedSegments[updatedSegments.length - 1].endTime)
        : null,
    };
  } catch (error) {
    console.error(`❌ エラー: ${id} - ${error.message}`);
    return { id, status: "error", error: error.message };
  }
}

/**
 * 指定レベルの全コンテンツの音声を生成
 */
async function generateByLevel(client, level, options) {
  const jsonPath = path.join(__dirname, CONFIG.jsonBasePath, `${level}.json`);

  const data = loadJsonFile(jsonPath);
  if (!data) {
    console.error(`❌ ${level}.json が見つかりません`);
    return;
  }

  console.log(
    `\n📚 ${level.toUpperCase()} レベル（${data.contents.length}件）\n`
  );

  const results = {
    success: 0,
    skipped: 0,
    error: 0,
  };

  let jsonUpdated = false;

  for (let i = 0; i < data.contents.length; i++) {
    const content = data.contents[i];
    const result = await generateAudio(
      client,
      { ...content, level },
      options
    );
    results[result.status === "dry-run" ? "success" : result.status]++;

    // タイムスタンプが取得できた場合、JSONデータを更新
    if (options.withTimestamps && result.segments) {
      data.contents[i].segments = result.segments;
      if (result.durationSeconds) {
        data.contents[i].durationSeconds = result.durationSeconds;
      }
      jsonUpdated = true;
    }

    // API制限を考慮して少し待機
    if (!options.dryRun) {
      await new Promise((resolve) => setTimeout(resolve, 500));
    }
  }

  // JSONファイルを更新
  if (jsonUpdated && !options.dryRun) {
    console.log(`\n📝 JSONファイルを更新しています...`);
    saveJsonFile(jsonPath, data);
  }

  console.log(
    `\n📊 結果: 成功=${results.success}, スキップ=${results.skipped}, エラー=${results.error}`
  );
  return results;
}

/**
 * 特定のIDの音声を生成
 */
async function generateById(client, id, options) {
  const match = id.match(/^(beginner|intermediate|advanced)_(\d+)$/);
  if (!match) {
    console.error(`❌ 無効なID形式です: ${id}`);
    console.error("   有効な形式: beginner_001, intermediate_015, advanced_040");
    return;
  }

  const [, level] = match;
  const jsonPath = path.join(__dirname, CONFIG.jsonBasePath, `${level}.json`);

  const data = loadJsonFile(jsonPath);
  if (!data) {
    console.error(`❌ ${level}.json が見つかりません`);
    return;
  }

  const contentIndex = data.contents.findIndex((c) => c.id === id);
  if (contentIndex === -1) {
    console.error(`❌ コンテンツが見つかりません: ${id}`);
    return;
  }

  const content = data.contents[contentIndex];

  console.log(`\n🎯 単一コンテンツ生成: ${id}\n`);
  const result = await generateAudio(client, { ...content, level }, options);

  // タイムスタンプが取得できた場合、JSONファイルを更新
  if (options.withTimestamps && result.segments && !options.dryRun) {
    data.contents[contentIndex].segments = result.segments;
    if (result.durationSeconds) {
      data.contents[contentIndex].durationSeconds = result.durationSeconds;
    }
    console.log(`\n📝 JSONファイルを更新しています...`);
    saveJsonFile(jsonPath, data);
  }
}

/**
 * 全レベルの音声を生成
 */
async function generateAll(client, options) {
  console.log("\n🚀 全レベルの音声を生成します\n");

  for (const level of Object.keys(CONFIG.levels)) {
    await generateByLevel(client, level, options);
  }
}

// ===== CLI =====

program
  .name("generate-audio")
  .description("シャドーイング用の音声ファイルを生成します")
  .version("1.0.0");

program
  .option(
    "-l, --level <level>",
    "生成するレベル (beginner, intermediate, advanced)"
  )
  .option("-i, --id <id>", "生成する特定のコンテンツID (例: beginner_001)")
  .option("-a, --all", "全レベルの音声を生成")
  .option("-f, --force", "既存のファイルを上書き")
  .option("-d, --dry-run", "実際には生成せずに対象を表示")
  .option("--voice <voice>", "音声タイプを指定 (例: ko-KR-Neural2-A)")
  .option(
    "--speed <speed>",
    "読み上げ速度 (0.25-4.0, デフォルト: 0.95)",
    parseFloat
  )
  .option(
    "-t, --with-timestamps",
    "タイムスタンプを取得してJSONのsegmentsを更新"
  );

program.parse();

const options = program.opts();

// メイン処理
(async () => {
  console.log("\n🎤 シャドーイング音声生成ツール\n");
  console.log("=".repeat(50));

  // オプションの適用
  if (options.voice) {
    CONFIG.voice.name = options.voice;
    console.log(`📢 音声タイプ: ${options.voice}`);
  }
  if (options.speed) {
    CONFIG.audioConfig.speakingRate = options.speed;
    console.log(`⏱️  読み上げ速度: ${options.speed}`);
  }
  if (options.dryRun) {
    console.log("🔍 ドライラン: 実際には生成しません");
  }
  if (options.force) {
    console.log("⚠️  既存ファイルを上書きします");
  }
  if (options.withTimestamps) {
    console.log("⏱️  タイムスタンプ取得モード: segments を自動更新します");
  }

  console.log("=".repeat(50));

  // Google Cloud TTS クライアントを初期化
  let client;
  if (!options.dryRun) {
    try {
      // v1beta1 APIを使用（timepointsサポートのため）
      if (options.withTimestamps) {
        client = new textToSpeech.v1beta1.TextToSpeechClient();
        console.log("✅ Google Cloud TTS クライアントを初期化しました (v1beta1)");
      } else {
        client = new textToSpeech.TextToSpeechClient();
        console.log("✅ Google Cloud TTS クライアントを初期化しました");
      }
    } catch (error) {
      console.error("❌ Google Cloud TTS クライアントの初期化に失敗しました");
      console.error(
        "   GOOGLE_APPLICATION_CREDENTIALS 環境変数を確認してください"
      );
      console.error(`   エラー: ${error.message}`);
      process.exit(1);
    }
  }

  // 処理の実行
  const processOptions = {
    dryRun: options.dryRun,
    force: options.force,
    withTimestamps: options.withTimestamps,
  };

  if (options.id) {
    await generateById(client, options.id, processOptions);
  } else if (options.level) {
    if (!CONFIG.levels[options.level]) {
      console.error(`❌ 無効なレベルです: ${options.level}`);
      console.error("   有効なレベル: beginner, intermediate, advanced");
      process.exit(1);
    }
    await generateByLevel(client, options.level, processOptions);
  } else if (options.all) {
    await generateAll(client, processOptions);
  } else {
    console.log("使用方法:");
    console.log(
      "  node generate-audio.js --level beginner    # 初級の音声を生成"
    );
    console.log(
      "  node generate-audio.js --level intermediate # 中級の音声を生成"
    );
    console.log(
      "  node generate-audio.js --level advanced     # 高級の音声を生成"
    );
    console.log(
      "  node generate-audio.js --id beginner_001    # 特定のコンテンツのみ生成"
    );
    console.log(
      "  node generate-audio.js --all                # 全レベルの音声を生成"
    );
    console.log("");
    console.log("オプション:");
    console.log("  --force            既存のファイルを上書き");
    console.log("  --dry-run          実際には生成せずに対象を表示");
    console.log("  --voice            音声タイプを指定 (例: ko-KR-Neural2-A)");
    console.log("  --speed            読み上げ速度 (0.25-4.0)");
    console.log(
      "  --with-timestamps  タイムスタンプを取得してJSONを更新（推奨）"
    );
    console.log("");
    console.log("例:");
    console.log(
      "  node generate-audio.js --level beginner --force --with-timestamps"
    );
    console.log("  # 初級の音声を再生成し、正確なタイムスタンプでJSONを更新");
  }

  console.log("\n✨ 完了\n");
})();
