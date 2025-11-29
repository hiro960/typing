-- AlterTable
ALTER TABLE "User" ADD COLUMN     "originalTransactionId" TEXT,
ADD COLUMN     "subscriptionAutoRenewing" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "subscriptionExpiresAt" TIMESTAMP(3),
ADD COLUMN     "subscriptionPlatform" TEXT,
ADD COLUMN     "subscriptionProductId" TEXT;
