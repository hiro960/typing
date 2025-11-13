/*
  Warnings:

  - You are about to drop the column `learningLevel` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `totalPracticeTime` on the `User` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('NORMAL', 'PREMIUM', 'OFFICIAL');

-- AlterTable
ALTER TABLE "User" DROP COLUMN "learningLevel",
DROP COLUMN "totalPracticeTime",
ADD COLUMN     "type" "UserType" NOT NULL DEFAULT 'NORMAL';
