import { PrismaClient, ActivityType } from "@prisma/client";

const prisma = new PrismaClient();

async function migrateActivityLog() {
  console.log("Starting ActivityLog migration...");

  // 1. LessonCompletionからActivityLogへ移行
  console.log("\n[Step 1] Migrating LessonCompletion to ActivityLog...");
  const lessonCompletions = await prisma.lessonCompletion.findMany({
    select: {
      id: true,
      userId: true,
      lessonId: true,
      wpm: true,
      accuracy: true,
      timeSpent: true,
      mode: true,
      completedAt: true,
    },
  });

  console.log(`Found ${lessonCompletions.length} lesson completions to migrate`);

  let lessonMigratedCount = 0;
  for (const completion of lessonCompletions) {
    // 既に移行済みかチェック（同じユーザー、同じ時刻のActivityLogが存在するか）
    const existing = await prisma.activityLog.findFirst({
      where: {
        userId: completion.userId,
        activityType: ActivityType.lesson,
        completedAt: completion.completedAt,
      },
    });

    if (existing) {
      continue; // 既に移行済み
    }

    await prisma.activityLog.create({
      data: {
        userId: completion.userId,
        activityType: ActivityType.lesson,
        timeSpent: completion.timeSpent,
        wpm: completion.wpm,
        accuracy: completion.accuracy,
        metadata: {
          lessonId: completion.lessonId,
          mode: completion.mode,
          migratedFrom: "LessonCompletion",
          originalId: completion.id,
        },
        completedAt: completion.completedAt,
      },
    });
    lessonMigratedCount++;
  }

  console.log(`Migrated ${lessonMigratedCount} lesson completions to ActivityLog`);

  // 2. RankingGameResultからActivityLogへ移行
  console.log("\n[Step 2] Migrating RankingGameResult to ActivityLog...");
  const rankingResults = await prisma.rankingGameResult.findMany({
    select: {
      id: true,
      userId: true,
      difficulty: true,
      score: true,
      avgInputSpeed: true,
      timeSpent: true,
      accuracy: true,
      playedAt: true,
    },
  });

  console.log(`Found ${rankingResults.length} ranking game results to migrate`);

  let rankingMigratedCount = 0;
  for (const result of rankingResults) {
    // 既に移行済みかチェック
    const existing = await prisma.activityLog.findFirst({
      where: {
        userId: result.userId,
        activityType: ActivityType.ranking_game,
        completedAt: result.playedAt,
      },
    });

    if (existing) {
      continue; // 既に移行済み
    }

    // timeSpentが未設定の場合はデフォルト値（60秒 = 60000ms）を使用
    const timeSpent = result.timeSpent ?? 60000;

    await prisma.activityLog.create({
      data: {
        userId: result.userId,
        activityType: ActivityType.ranking_game,
        timeSpent: timeSpent,
        wpm: result.avgInputSpeed,
        accuracy: result.accuracy,
        metadata: {
          difficulty: result.difficulty,
          score: result.score,
          migratedFrom: "RankingGameResult",
          originalId: result.id,
        },
        completedAt: result.playedAt,
      },
    });
    rankingMigratedCount++;
  }

  console.log(`Migrated ${rankingMigratedCount} ranking game results to ActivityLog`);

  // 3. 移行結果のサマリー
  console.log("\n[Summary]");
  const totalActivityLogs = await prisma.activityLog.count();
  const lessonLogs = await prisma.activityLog.count({
    where: { activityType: ActivityType.lesson },
  });
  const rankingLogs = await prisma.activityLog.count({
    where: { activityType: ActivityType.ranking_game },
  });

  console.log(`Total ActivityLog records: ${totalActivityLogs}`);
  console.log(`  - Lesson activities: ${lessonLogs}`);
  console.log(`  - Ranking game activities: ${rankingLogs}`);

  console.log("\nActivityLog migration completed successfully!");
}

async function main() {
  try {
    await migrateActivityLog();
  } catch (error) {
    console.error("Migration failed:", error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

main();
