-- CreateEnum
CREATE TYPE "ActivityType" AS ENUM ('lesson', 'ranking_game');

-- AlterTable
ALTER TABLE "RankingGameResult" ADD COLUMN     "accuracy" DOUBLE PRECISION,
ADD COLUMN     "timeSpent" INTEGER;

-- CreateTable
CREATE TABLE "ActivityLog" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "activityType" "ActivityType" NOT NULL,
    "timeSpent" INTEGER NOT NULL,
    "wpm" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "metadata" JSONB,
    "completedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ActivityLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ActivityLog_userId_idx" ON "ActivityLog"("userId");

-- CreateIndex
CREATE INDEX "ActivityLog_userId_completedAt_idx" ON "ActivityLog"("userId", "completedAt");

-- CreateIndex
CREATE INDEX "ActivityLog_activityType_idx" ON "ActivityLog"("activityType");

-- AddForeignKey
ALTER TABLE "ActivityLog" ADD CONSTRAINT "ActivityLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
