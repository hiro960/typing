-- CreateEnum
CREATE TYPE "RankingGameDifficulty" AS ENUM ('beginner', 'intermediate', 'advanced');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "bestRankingScore" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "RankingGameResult" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "difficulty" "RankingGameDifficulty" NOT NULL,
    "score" INTEGER NOT NULL,
    "correctCount" INTEGER NOT NULL,
    "maxCombo" INTEGER NOT NULL,
    "totalBonusTime" INTEGER NOT NULL,
    "avgInputSpeed" DOUBLE PRECISION NOT NULL,
    "characterLevel" INTEGER NOT NULL,
    "playedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RankingGameResult_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "RankingGameResult_userId_idx" ON "RankingGameResult"("userId");

-- CreateIndex
CREATE INDEX "RankingGameResult_difficulty_idx" ON "RankingGameResult"("difficulty");

-- CreateIndex
CREATE INDEX "RankingGameResult_score_idx" ON "RankingGameResult"("score");

-- CreateIndex
CREATE INDEX "RankingGameResult_playedAt_idx" ON "RankingGameResult"("playedAt");

-- CreateIndex
CREATE INDEX "RankingGameResult_difficulty_playedAt_score_idx" ON "RankingGameResult"("difficulty", "playedAt", "score");

-- AddForeignKey
ALTER TABLE "RankingGameResult" ADD CONSTRAINT "RankingGameResult_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
