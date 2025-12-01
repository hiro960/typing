/*
  Warnings:

  - You are about to drop the column `bestRankingScore` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `maxAccuracy` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `maxWPM` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `totalLessonsCompleted` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "bestRankingScore",
DROP COLUMN "maxAccuracy",
DROP COLUMN "maxWPM",
DROP COLUMN "totalLessonsCompleted";
