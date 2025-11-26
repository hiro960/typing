import { NextRequest, NextResponse } from "next/server";
import { handleRouteError } from "@/lib/errors";
import { requireAuthUser } from "@/lib/auth";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

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

        // Fetch completions (include timeSpent for practice time stats)
        const completions = await prisma.lessonCompletion.findMany({
            where: {
                userId: user.id,
                ...(dateFrom ? { completedAt: { gte: dateFrom } } : {}),
            },
            orderBy: { completedAt: "asc" },
            select: {
                wpm: true,
                accuracy: true,
                mistakeCharacters: true,
                completedAt: true,
                timeSpent: true,
            },
        });

        // 1. Weak Keys
        const mistakeCounts: Record<string, number> = {};
        completions.forEach((c) => {
            if (c.mistakeCharacters && typeof c.mistakeCharacters === "object") {
                const mistakes = c.mistakeCharacters as Record<string, number>;
                Object.entries(mistakes).forEach(([key, count]) => {
                    mistakeCounts[key] = (mistakeCounts[key] || 0) + count;
                });
            }
        });

        const weakKeys = Object.entries(mistakeCounts)
            .map(([key, count]) => ({ key, count }))
            .sort((a, b) => b.count - a.count)
            .slice(0, 5); // Top 5

        // 2. Growth Trends (Daily Average)
        const trendsMap: Record<
            string,
            { totalWpm: number; totalAcc: number; count: number }
        > = {};

        completions.forEach((c) => {
            const dateKey = c.completedAt.toISOString().split("T")[0];
            if (!trendsMap[dateKey]) {
                trendsMap[dateKey] = { totalWpm: 0, totalAcc: 0, count: 0 };
            }
            trendsMap[dateKey].totalWpm += c.wpm;
            trendsMap[dateKey].totalAcc += c.accuracy;
            trendsMap[dateKey].count += 1;
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

        completions.forEach((c) => {
            const date = new Date(c.completedAt);
            const hour = date.getHours();
            const day = date.getDay();

            byHour[hour]++;
            byDayOfWeek[day]++;
        });

        // 4. Practice Time Statistics
        const totalTimeMs = completions.reduce((sum, c) => sum + c.timeSpent, 0);
        const sessionCount = completions.length;
        const averageTimeMs = sessionCount > 0 ? Math.round(totalTimeMs / sessionCount) : 0;

        // Daily practice time for chart
        const dailyTimeMap: Record<string, number> = {};
        completions.forEach((c) => {
            const dateKey = c.completedAt.toISOString().split("T")[0];
            dailyTimeMap[dateKey] = (dailyTimeMap[dateKey] || 0) + c.timeSpent;
        });

        const dailyPracticeTime = Object.entries(dailyTimeMap)
            .map(([date, timeMs]) => ({ date, timeMs }))
            .sort((a, b) => a.date.localeCompare(b.date));

        const practiceTime = {
            totalTimeMs,
            sessionCount,
            averageTimeMs,
            dailyPracticeTime,
        };

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
        });
    } catch (error) {
        return handleRouteError(error);
    }
}
