# シャドーイング音声生成ツール

Google Cloud Text-to-Speech API を使用して、シャドーイングコンテンツの音声ファイル（MP3）を生成するスクリプトです。

## 前提条件

### 1. Node.js のインストール

Node.js v18 以上が必要です。

### 2. Google Cloud プロジェクトの設定

1. [Google Cloud Console](https://console.cloud.google.com/) でプロジェクトを作成
2. Text-to-Speech API を有効化
3. サービスアカウントを作成し、JSON キーをダウンロード

### 3. 認証情報の設定

サービスアカウントのJSONキーファイルのパスを環境変数に設定します：

```bash
# macOS/Linux
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"

# Windows (PowerShell)
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\your\service-account-key.json"
```

## セットアップ

```bash
cd tools/shadowing-audio-generator
npm install
```

## 使用方法

### 基本コマンド

```bash
# 初級の音声を全て生成
node generate-audio.js --level beginner

# 中級の音声を全て生成
node generate-audio.js --level intermediate

# 高級の音声を全て生成
node generate-audio.js --level advanced

# 全レベルの音声を生成
node generate-audio.js --all

# 特定のコンテンツのみ生成
node generate-audio.js --id beginner_001
```

### オプション

| オプション | 説明 |
|-----------|------|
| `-l, --level <level>` | 生成するレベル (beginner, intermediate, advanced) |
| `-i, --id <id>` | 生成する特定のコンテンツID (例: beginner_001) |
| `-a, --all` | 全レベルの音声を生成 |
| `-f, --force` | 既存のファイルを上書き |
| `-d, --dry-run` | 実際には生成せずに対象を表示 |
| `-t, --with-timestamps` | **タイムスタンプを取得してJSONを自動更新（推奨）** |
| `--voice <voice>` | 音声タイプを指定 |
| `--speed <speed>` | 読み上げ速度 (0.25-4.0) |

### 使用例

```bash
# ドライランで対象を確認
node generate-audio.js --level beginner --dry-run

# 既存ファイルを上書きして再生成
node generate-audio.js --id beginner_001 --force

# 男性音声で生成
node generate-audio.js --level beginner --voice ko-KR-Neural2-C

# ゆっくりとした速度で生成
node generate-audio.js --level beginner --speed 0.8

# 【推奨】タイムスタンプ付きで生成（JSONも自動更新）
node generate-audio.js --level beginner --force --with-timestamps
```

## タイムスタンプ自動取得機能（--with-timestamps）

`--with-timestamps` オプションを使用すると、音声生成時に各セグメントの正確な `startTime` / `endTime` を自動取得し、JSONファイルを更新します。

### 仕組み

1. JSONの `segments` 配列から各文を読み取り
2. 各セグメントの前後に `<mark>` タグを挿入したSSMLを生成
3. Google Cloud TTS の `enableTimePointing` オプションでタイムスタンプを取得
4. 取得したタイムスタンプでJSONの `segments[].startTime` / `segments[].endTime` を更新
5. `durationSeconds` も実際の音声長さで更新

### 使い方

```bash
# 初級の音声を再生成し、タイムスタンプでJSONを更新
node generate-audio.js --level beginner --force --with-timestamps

# 特定のコンテンツのみ
node generate-audio.js --id beginner_001 --force --with-timestamps

# 全レベルを一括処理
node generate-audio.js --all --force --with-timestamps
```

### 出力例

```
🎙️  生成中: beginner_001 - 自己紹介をしよう
✅ 完了: beginner_001 -> 001.mp3
   ⏱️  タイムスタンプ取得: 12個のマーク
      [0] 0.00s - 4.52s: 저는 일본에서 온 사토입니다...
      [1] 4.52s - 9.87s: 지금 서울에서 한국어를 공부...
      [2] 9.87s - 14.23s: 취미는 음악 듣기와 여행입...
      ...

📝 JSONファイルを更新しています...
💾 JSONファイルを保存しました: .../beginner.json
```

### 注意事項

- `--force` オプションと併用してください（既存のMP3を再生成するため）
- JSONの `segments` 配列が必要です（segmentsがないコンテンツはスキップされます）
- 追加のAPI費用はかかりません（TTS生成と同時にタイムスタンプを取得）

## 音声タイプ

Google Cloud TTS で使用可能な韓国語音声：

### Neural2（最高品質、推奨）

| 音声名 | 性別 | 説明 |
|--------|------|------|
| ko-KR-Neural2-A | 女性 | 高品質な女性音声（デフォルト） |
| ko-KR-Neural2-B | 女性 | 別の女性音声 |
| ko-KR-Neural2-C | 男性 | 高品質な男性音声 |

### Wavenet（高品質）

| 音声名 | 性別 | 説明 |
|--------|------|------|
| ko-KR-Wavenet-A | 女性 | 女性音声 |
| ko-KR-Wavenet-B | 男性 | 男性音声 |
| ko-KR-Wavenet-C | 男性 | 別の男性音声 |
| ko-KR-Wavenet-D | 女性 | 別の女性音声 |

### Standard（標準品質）

| 音声名 | 性別 | 説明 |
|--------|------|------|
| ko-KR-Standard-A | 女性 | 標準女性音声 |
| ko-KR-Standard-B | 女性 | 別の標準女性音声 |
| ko-KR-Standard-C | 男性 | 標準男性音声 |
| ko-KR-Standard-D | 男性 | 別の標準男性音声 |

## 出力ファイル

生成された音声ファイルは以下のディレクトリに保存されます：

```
application/assets/audio/shadowing/
├── beginner/
│   ├── 001.mp3
│   ├── 002.mp3
│   └── ... (020.mp3まで)
├── intermediate/
│   ├── 001.mp3
│   └── ... (030.mp3まで)
└── advanced/
    ├── 001.mp3
    └── ... (040.mp3まで)
```

## 入力ファイル

スクリプトは以下のJSONファイルを読み込みます：

```
application/assets/data/shadowing/
├── beginner.json
├── intermediate.json
└── advanced.json
```

各JSONファイルは以下の形式である必要があります：

```json
{
  "version": "1.0.0",
  "level": "beginner",
  "contents": [
    {
      "id": "beginner_001",
      "title": "自己紹介をしよう",
      "text": "저는 일본에서 온 사토입니다...",
      "meaning": "私は日本から来たサトウです...",
      "audioPath": "assets/audio/shadowing/beginner/001.mp3",
      "durationSeconds": 45,
      "tip": "発音のポイント...",
      "segments": [...]
    }
  ]
}
```

## 料金について

Google Cloud TTS は使用量に応じて課金されます：

| 音声タイプ | 料金（100万文字あたり） |
|-----------|----------------------|
| Standard | $4.00 |
| Wavenet | $16.00 |
| Neural2 | $16.00 |

詳細は [Google Cloud TTS 料金](https://cloud.google.com/text-to-speech/pricing) を参照してください。

## トラブルシューティング

### 認証エラーが発生する場合

```
❌ Google Cloud TTS クライアントの初期化に失敗しました
   GOOGLE_APPLICATION_CREDENTIALS 環境変数を確認してください
```

→ `GOOGLE_APPLICATION_CREDENTIALS` 環境変数が正しく設定されているか確認してください。

### API が有効化されていない場合

```
Error: Text-to-Speech API has not been used in project...
```

→ Google Cloud Console で Text-to-Speech API を有効化してください。

### JSONファイルが見つからない場合

```
❌ beginner.json が見つかりません
```

→ `application/assets/data/shadowing/` ディレクトリにJSONファイルが存在するか確認してください。

## 注意事項

1. **API制限**: 短時間に大量のリクエストを送ると制限がかかる場合があります。スクリプトは各リクエスト間に500msの待機時間を設けています。

2. **料金**: Neural2/Wavenet音声は高品質ですが、料金も高くなります。テスト時はStandard音声を使用することを推奨します。

3. **既存ファイル**: デフォルトでは既存のファイルはスキップされます。再生成する場合は `--force` オプションを使用してください。
