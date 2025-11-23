import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  console.log("Starting seed...");

  // 既存のレッスンをクリア（開発環境のみ）
  if (process.env.NODE_ENV === "development") {
    await prisma.lessonCompletion.deleteMany();
    await prisma.lesson.deleteMany();
    console.log("Cleared existing lessons");
  }

  // 初級レッスン (20レッスン)
  const beginnerLessons = [
    { id: "les_beginner_001", order: 1, title: "基本の文字 ㅜ, ㅇ, ㅁ", estimatedMinutes: 5 },
    { id: "les_beginner_002", order: 2, title: "基本の文字 ㅂ, ㅣ", estimatedMinutes: 5 },
    { id: "les_beginner_003", order: 3, title: "基本の文字 ㄱ", estimatedMinutes: 5 },
    { id: "les_beginner_004", order: 4, title: "基本の文字 ㄴ, ㄷ", estimatedMinutes: 5 },
    { id: "les_beginner_005", order: 5, title: "基本の文字 ㄹ, ㅅ", estimatedMinutes: 5 },
    { id: "les_beginner_006", order: 6, title: "基本の文字 ㅈ, ㅓ", estimatedMinutes: 5 },
    { id: "les_beginner_007", order: 7, title: "基本の文字 ㅎ, ㅗ", estimatedMinutes: 5 },
    { id: "les_beginner_008", order: 8, title: "激音 ㅋ, ㅌ, ㅍ", estimatedMinutes: 8 },
    { id: "les_beginner_009", order: 9, title: "激音 ㅊ", estimatedMinutes: 5 },
    { id: "les_beginner_010", order: 10, title: "母音 ㅐ, ㅔ", estimatedMinutes: 5 },
    { id: "les_beginner_011", order: 11, title: "母音 ㅡ", estimatedMinutes: 5 },
    { id: "les_beginner_012", order: 12, title: "濃音 ㄲ, ㄸ, ㅃ", estimatedMinutes: 8 },
    { id: "les_beginner_013", order: 13, title: "濃音 ㅆ, ㅉ", estimatedMinutes: 5 },
    { id: "les_beginner_014", order: 14, title: "複合母音 ㅑ, ㅕ, ㅛ, ㅠ", estimatedMinutes: 8 },
    { id: "les_beginner_015", order: 15, title: "複合母音 ㅘ, ㅝ, ㅢ, ㅚ, ㅟ", estimatedMinutes: 10 },
    { id: "les_beginner_016", order: 16, title: "パッチム基礎", estimatedMinutes: 10 },
    { id: "les_beginner_017", order: 17, title: "パッチム応用", estimatedMinutes: 10 },
    { id: "les_beginner_018", order: 18, title: "二重パッチム ㄳ, ㄺ, ㄻ", estimatedMinutes: 10 },
    { id: "les_beginner_019", order: 19, title: "二重パッチム ㄼ, ㄽ, ㄾ, ㄿ, ㅀ, ㅄ", estimatedMinutes: 12 },
    { id: "les_beginner_020", order: 20, title: "総復習 - 日常会話フレーズ", estimatedMinutes: 15 },
  ].map(lesson => ({ ...lesson, level: "beginner" }));

  // 中級レッスン (20レッスン)
  const intermediateLessons = [
    { id: "les_intermediate_001", order: 1, title: "数字①（基本数字）", estimatedMinutes: 10 },
    { id: "les_intermediate_002", order: 2, title: "数字②（固有数詞・時間）", estimatedMinutes: 12 },
    { id: "les_intermediate_003", order: 3, title: "家族・人間関係①", estimatedMinutes: 10 },
    { id: "les_intermediate_004", order: 4, title: "家族・人間関係②", estimatedMinutes: 12 },
    { id: "les_intermediate_005", order: 5, title: "食べ物①（主食・料理）", estimatedMinutes: 12 },
    { id: "les_intermediate_006", order: 6, title: "食べ物②（飲み物・その他）", estimatedMinutes: 12 },
    { id: "les_intermediate_007", order: 7, title: "場所①（基本的な場所）", estimatedMinutes: 10 },
    { id: "les_intermediate_008", order: 8, title: "場所②（施設・位置）", estimatedMinutes: 12 },
    { id: "les_intermediate_009", order: 9, title: "日常動詞①（基本動作）", estimatedMinutes: 12 },
    { id: "les_intermediate_010", order: 10, title: "日常動詞②（生活動作）", estimatedMinutes: 12 },
    { id: "les_intermediate_011", order: 11, title: "日常動詞③（コミュニケーション）", estimatedMinutes: 12 },
    { id: "les_intermediate_012", order: 12, title: "日常動詞④（感情・状態）", estimatedMinutes: 12 },
    { id: "les_intermediate_013", order: 13, title: "形容詞①（性格・性質）", estimatedMinutes: 12 },
    { id: "les_intermediate_014", order: 14, title: "形容詞②（状態・様子）", estimatedMinutes: 12 },
    { id: "les_intermediate_015", order: 15, title: "形容詞③（感情①）", estimatedMinutes: 12 },
    { id: "les_intermediate_016", order: 16, title: "形容詞④（感覚・体調）", estimatedMinutes: 12 },
    { id: "les_intermediate_017", order: 17, title: "時間・頻度表現", estimatedMinutes: 12 },
    { id: "les_intermediate_018", order: 18, title: "日常名詞（物・事）", estimatedMinutes: 12 },
    { id: "les_intermediate_019", order: 19, title: "接続詞・副詞・疑問詞", estimatedMinutes: 12 },
    { id: "les_intermediate_020", order: 20, title: "総復習 - 日常会話フレーズ", estimatedMinutes: 15 },
  ].map(lesson => ({ ...lesson, level: "intermediate" }));

  // 上級レッスン (20レッスン)
  const advancedLessons = [
    { id: "les_advanced_001", order: 1, title: "日常会話文①（挨拶・自己紹介）", estimatedMinutes: 15 },
    { id: "les_advanced_002", order: 2, title: "日常会話文②（日常生活）", estimatedMinutes: 15 },
    { id: "les_advanced_003", order: 3, title: "短いエッセイ①（私の一日）", estimatedMinutes: 18 },
    { id: "les_advanced_004", order: 4, title: "短いエッセイ②（私の趣味）", estimatedMinutes: 18 },
    { id: "les_advanced_005", order: 5, title: "ニュース記事①（天気・季節）", estimatedMinutes: 20 },
    { id: "les_advanced_006", order: 6, title: "ニュース記事②（イベント・お知らせ）", estimatedMinutes: 20 },
    { id: "les_advanced_007", order: 7, title: "会話文（レストランでの注文）", estimatedMinutes: 18 },
    { id: "les_advanced_008", order: 8, title: "SNSフレーズ①（応援メッセージ）", estimatedMinutes: 15 },
    { id: "les_advanced_009", order: 9, title: "SNSフレーズ②（感想・コメント）", estimatedMinutes: 15 },
    { id: "les_advanced_010", order: 10, title: "ファンレター①（基本形式）", estimatedMinutes: 20 },
    { id: "les_advanced_011", order: 11, title: "ファンレター②（感謝の気持ち）", estimatedMinutes: 20 },
    { id: "les_advanced_012", order: 12, title: "ファンミーティング感想", estimatedMinutes: 20 },
    { id: "les_advanced_013", order: 13, title: "応援メッセージ（長文）", estimatedMinutes: 22 },
    { id: "les_advanced_014", order: 14, title: "投票・支援呼びかけ", estimatedMinutes: 18 },
    { id: "les_advanced_015", order: 15, title: "ことわざ①（努力・成功）", estimatedMinutes: 15 },
    { id: "les_advanced_016", order: 16, title: "ことわざ②（人間関係）", estimatedMinutes: 15 },
    { id: "les_advanced_017", order: 17, title: "ことわざ③（人生の教訓）", estimatedMinutes: 15 },
    { id: "les_advanced_018", order: 18, title: "慣用句①（感情表現）", estimatedMinutes: 15 },
    { id: "les_advanced_019", order: 19, title: "慣用句②（日常表現）", estimatedMinutes: 15 },
    { id: "les_advanced_020", order: 20, title: "総復習 - 実践文章", estimatedMinutes: 25 },
  ].map(lesson => ({ ...lesson, level: "advanced" }));

  const allLessons = [
    ...beginnerLessons,
    ...intermediateLessons,
    ...advancedLessons,
  ];

  // レッスンを登録
  for (const lesson of allLessons) {
    await prisma.lesson.upsert({
      where: { id: lesson.id },
      update: {
        title: lesson.title,
        level: lesson.level,
        order: lesson.order,
        estimatedMinutes: lesson.estimatedMinutes,
      },
      create: lesson,
    });
    console.log(`Upserted lesson: ${lesson.id} - ${lesson.title}`);
  }

  console.log(`Seed completed successfully! Total lessons created: ${allLessons.length}`);
}

main()
  .catch((e) => {
    console.error("Seed failed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
