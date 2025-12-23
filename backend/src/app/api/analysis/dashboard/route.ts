import { NextRequest, NextResponse } from "next/server";
import { handleRouteError } from "@/lib/errors";
import { requireAuthUser } from "@/lib/auth";
import prisma from "@/lib/prisma";

export async function GET(request: NextRequest) {
    try {
        const user = await requireAuthUser(request);
        const { searchParams } = request.nextUrl;
        const period = searchParams.get("period") || "month"; // 'week', 'month', 'half_year'

        // Calculate date range
        let dateFrom: Date | undefined;
        const now = new Date();
        if (period === "week") {
            dateFrom = new Date(now.setDate(now.getDate() - 7));
        } else if (period === "month") {
            dateFrom = new Date(now.setMonth(now.getMonth() - 1));
        } else if (period === "half_year") {
            dateFrom = new Date(now.setMonth(now.getMonth() - 6));
        }

        // ActivityLogから統合データを取得（レッスン + ランキングゲーム）
        const activities = await prisma.activityLog.findMany({
            where: {
                userId: user.id,
                ...(dateFrom ? { completedAt: { gte: dateFrom } } : {}),
            },
            orderBy: { completedAt: "asc" },
            select: {
                activityType: true,
                wpm: true,
                accuracy: true,
                metadata: true,
                completedAt: true,
                timeSpent: true,
            },
        });

        // 1. Weak Keys（metadataからmistakeCharactersを抽出）
        const mistakeCounts: Record<string, number> = {};
        activities.forEach((a) => {
            if (a.metadata && typeof a.metadata === "object") {
                const meta = a.metadata as Record<string, unknown>;
                if (meta.mistakeCharacters && typeof meta.mistakeCharacters === "object") {
                    const mistakes = meta.mistakeCharacters as Record<string, number>;
                    Object.entries(mistakes).forEach(([key, count]) => {
                        mistakeCounts[key] = (mistakeCounts[key] || 0) + count;
                    });
                }
            }
        });

        const weakKeys = Object.entries(mistakeCounts)
            .map(([key, count]) => ({ key, count }))
            .sort((a, b) => b.count - a.count)
            .slice(0, 5); // Top 5

        // 2. Growth Trends (Daily Average) - WPMがあるアクティビティのみ
        const trendsMap: Record<
            string,
            { totalWpm: number; totalAcc: number; count: number }
        > = {};

        activities.forEach((a) => {
            if (a.wpm !== null && a.accuracy !== null) {
                const dateKey = a.completedAt.toISOString().split("T")[0];
                if (!trendsMap[dateKey]) {
                    trendsMap[dateKey] = { totalWpm: 0, totalAcc: 0, count: 0 };
                }
                trendsMap[dateKey].totalWpm += a.wpm;
                trendsMap[dateKey].totalAcc += a.accuracy;
                trendsMap[dateKey].count += 1;
            }
        });

        const trends = Object.entries(trendsMap)
            .map(([date, data]) => ({
                date,
                wpm: Math.round(data.totalWpm / data.count),
                accuracy: parseFloat((data.totalAcc / data.count).toFixed(1)),
            }))
            .sort((a, b) => a.date.localeCompare(b.date));

        // 3. Learning Habits
        // Initialize arrays
        const byHour = new Array(24).fill(0);
        const byDayOfWeek = new Array(7).fill(0); // 0: Sun, 6: Sat

        activities.forEach((a) => {
            const date = new Date(a.completedAt);
            const hour = date.getHours();
            const day = date.getDay();

            byHour[hour]++;
            byDayOfWeek[day]++;
        });

        // 4. Practice Time Statistics（レッスン + ランキングゲーム統合）
        const totalTimeMs = activities.reduce((sum, a) => sum + a.timeSpent, 0);
        const sessionCount = activities.length;
        const averageTimeMs = sessionCount > 0 ? Math.round(totalTimeMs / sessionCount) : 0;

        // Daily practice time for chart（アクティビティタイプ別に分類）
        const dailyTimeMap: Record<string, { lesson: number; rankingGame: number }> = {};
        activities.forEach((a) => {
            const dateKey = a.completedAt.toISOString().split("T")[0];
            if (!dailyTimeMap[dateKey]) {
                dailyTimeMap[dateKey] = { lesson: 0, rankingGame: 0 };
            }
            if (a.activityType === "lesson") {
                dailyTimeMap[dateKey].lesson += a.timeSpent;
            } else {
                dailyTimeMap[dateKey].rankingGame += a.timeSpent;
            }
        });

        const dailyPracticeTime = Object.entries(dailyTimeMap)
            .map(([date, times]) => ({
                date,
                timeMs: times.lesson + times.rankingGame,
                lessonTimeMs: times.lesson,
                rankingGameTimeMs: times.rankingGame,
            }))
            .sort((a, b) => a.date.localeCompare(b.date));

        const practiceTime = {
            totalTimeMs,
            sessionCount,
            averageTimeMs,
            dailyPracticeTime,
        };

        // 4.5 Activity Breakdown（アクティビティ種別ごとの時間内訳）
        type ActivityBreakdownEntry = { timeSpentMs: number; sessionCount: number };
        const activityBreakdown: Record<string, ActivityBreakdownEntry> = {
            lesson: { timeSpentMs: 0, sessionCount: 0 },
            rankingGame: { timeSpentMs: 0, sessionCount: 0 },
            pronunciationGame: { timeSpentMs: 0, sessionCount: 0 },
            quickTranslation: { timeSpentMs: 0, sessionCount: 0 },
            writing: { timeSpentMs: 0, sessionCount: 0 },
            hanjaQuiz: { timeSpentMs: 0, sessionCount: 0 },
        };

        // 日別アクティビティ内訳用のマップ
        type DailyActivityEntry = {
            lesson: number;
            rankingGame: number;
            pronunciationGame: number;
            quickTranslation: number;
            writing: number;
            hanjaQuiz: number;
        };
        const dailyActivityMap: Record<string, DailyActivityEntry> = {};

        activities.forEach((a) => {
            const dateKey = a.completedAt.toISOString().split("T")[0];
            if (!dailyActivityMap[dateKey]) {
                dailyActivityMap[dateKey] = {
                    lesson: 0,
                    rankingGame: 0,
                    pronunciationGame: 0,
                    quickTranslation: 0,
                    writing: 0,
                    hanjaQuiz: 0,
                };
            }

            // アクティビティタイプをキーにマッピング
            const typeKeyMap: Record<string, string> = {
                lesson: "lesson",
                ranking_game: "rankingGame",
                pronunciation_game: "pronunciationGame",
                quick_translation: "quickTranslation",
                writing: "writing",
                hanja_quiz: "hanjaQuiz",
            };
            const key = typeKeyMap[a.activityType] || "lesson";

            // 合計集計
            activityBreakdown[key].timeSpentMs += a.timeSpent;
            activityBreakdown[key].sessionCount += 1;

            // 日別集計
            dailyActivityMap[dateKey][key as keyof DailyActivityEntry] += a.timeSpent;
        });

        const dailyActivityBreakdown = Object.entries(dailyActivityMap)
            .map(([date, times]) => ({
                date,
                lessonTimeMs: times.lesson,
                rankingGameTimeMs: times.rankingGame,
                pronunciationGameTimeMs: times.pronunciationGame,
                quickTranslationTimeMs: times.quickTranslation,
                writingTimeMs: times.writing,
                hanjaQuizTimeMs: times.hanjaQuiz,
            }))
            .sort((a, b) => a.date.localeCompare(b.date));

        // 5. Vocabulary Status (from Wordbook)
        const wordbookStats = await prisma.wordbook.groupBy({
            by: ["status"],
            where: { userId: user.id },
            _count: { status: true },
        });

        const vocabularyStatus = {
            mastered: 0,
            reviewing: 0,
            needsReview: 0,
            total: 0,
        };

        wordbookStats.forEach((stat) => {
            const count = stat._count.status;
            vocabularyStatus.total += count;
            switch (stat.status) {
                case "MASTERED":
                    vocabularyStatus.mastered = count;
                    break;
                case "REVIEWING":
                    vocabularyStatus.reviewing = count;
                    break;
                case "NEEDS_REVIEW":
                    vocabularyStatus.needsReview = count;
                    break;
            }
        });

        // 6. Vocabulary Growth (monthly aggregation)
        const wordbooks = await prisma.wordbook.findMany({
            where: {
                userId: user.id,
                ...(dateFrom ? { createdAt: { gte: dateFrom } } : {}),
            },
            select: {
                createdAt: true,
                status: true,
            },
            orderBy: { createdAt: "asc" },
        });

        // Group by month (YYYY-MM format)
        const monthlyGrowthMap: Record<string, { added: number; mastered: number }> = {};
        wordbooks.forEach((w) => {
            const monthKey = w.createdAt.toISOString().slice(0, 7); // YYYY-MM
            if (!monthlyGrowthMap[monthKey]) {
                monthlyGrowthMap[monthKey] = { added: 0, mastered: 0 };
            }
            monthlyGrowthMap[monthKey].added += 1;
            if (w.status === "MASTERED") {
                monthlyGrowthMap[monthKey].mastered += 1;
            }
        });

        const vocabularyGrowth = Object.entries(monthlyGrowthMap)
            .map(([month, data]) => ({
                month,
                added: data.added,
                mastered: data.mastered,
            }))
            .sort((a, b) => a.month.localeCompare(b.month));

        // 7. Diary Calendar - get posting dates for current month
        const calendarMonth = searchParams.get("calendarMonth");
        let calendarYear: number;
        let calendarMonthNum: number;

        if (calendarMonth) {
            const [y, m] = calendarMonth.split("-").map(Number);
            calendarYear = y;
            calendarMonthNum = m;
        } else {
            const today = new Date();
            calendarYear = today.getFullYear();
            calendarMonthNum = today.getMonth() + 1;
        }

        const calendarStart = new Date(calendarYear, calendarMonthNum - 1, 1);
        const calendarEnd = new Date(calendarYear, calendarMonthNum, 0, 23, 59, 59, 999);

        const diaryPosts = await prisma.post.findMany({
            where: {
                userId: user.id,
                createdAt: {
                    gte: calendarStart,
                    lte: calendarEnd,
                },
            },
            select: {
                createdAt: true,
            },
            orderBy: { createdAt: "asc" },
        });

        // Extract unique dates
        const postDatesSet = new Set<string>();
        diaryPosts.forEach((post) => {
            const dateKey = post.createdAt.toISOString().split("T")[0];
            postDatesSet.add(dateKey);
        });

        const diaryCalendar = {
            year: calendarYear,
            month: calendarMonthNum,
            postDates: Array.from(postDatesSet).sort(),
            totalPosts: diaryPosts.length,
        };

        return NextResponse.json({
            weakKeys,
            trends,
            habits: {
                byHour,
                byDayOfWeek,
            },
            practiceTime,
            vocabularyStatus,
            vocabularyGrowth,
            activityBreakdown,
            dailyActivityBreakdown,
            diaryCalendar,
        });
    } catch (error) {
        return handleRouteError(error);
    }
}
