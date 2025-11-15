-- CreateEnum
CREATE TYPE "DeviceType" AS ENUM ('ios', 'android', 'web');

-- CreateEnum
CREATE TYPE "LessonMode" AS ENUM ('standard', 'challenge');

-- AlterTable
ALTER TABLE "Lesson" ADD COLUMN     "assetPath" TEXT,
ADD COLUMN     "assetVersion" INTEGER,
ADD COLUMN     "estimatedMinutes" INTEGER NOT NULL DEFAULT 10,
ALTER COLUMN "content" DROP NOT NULL;

-- AlterTable
ALTER TABLE "LessonCompletion" ADD COLUMN     "device" "DeviceType" NOT NULL DEFAULT 'ios',
ADD COLUMN     "mode" "LessonMode" NOT NULL DEFAULT 'standard';
