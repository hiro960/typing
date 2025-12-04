import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "チャレッタ",
  description: "あなたの韓国語学習をサポートするオールインワンアプリ。",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  );
}
