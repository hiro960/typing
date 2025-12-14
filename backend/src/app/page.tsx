import Image from "next/image";
import { FaInstagram, FaTiktok, FaXTwitter } from "react-icons/fa6";
import { SiLine } from "react-icons/si";
import styles from "./page.module.css";

export default function Home() {
  return (
    <div className={styles.container}>
      <main className={styles.main}>
        {/* Hero Section */}
        <section className={styles.hero}>
          <div className={styles.heroContent}>
            <h2 className={styles.title}>
              韓国語の学習を、<br />もっと楽しく、効果的に。
            </h2>
            <p className={styles.subtitle}>
              タイピング練習からTOPIK対策まで。<br />
              あなたの韓国語学習をサポートするオールインワンアプリ
            </p>
            <h1 className={styles.appName}>チャレッタ</h1>
            <div className={styles.comingSoonBanner}>
              <p className={styles.comingSoonText}>2025年12月末日公開予定！</p>
            </div>
          </div>
          <div className={styles.heroImageWrapper}>
            <Image
              src="/screen/screen-top.png"
              alt="App Dashboard"
              width={1000}
              height={600}
              priority
              style={{ width: "100%", height: "auto" }}
            />
          </div>
        </section>

        {/* Features Section */}
        <section id="features" className={styles.features}>
          {/* Feature 1: Typing */}
          <div className={styles.featureRow}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>実践的なタイピング練習</h2>
              <p className={styles.featureDescription}>
                単語から文章まで気持ちよくタイピング練習。<br />
                正確な指使いとスピードを身につけながら、自然な韓国語表現も学べます。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-typing.png"
                alt="Typing Practice Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 2: Wordbook (Reverse) */}
          <div className={`${styles.featureRow} ${styles.reverse}`}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>自分だけの単語帳</h2>
              <p className={styles.featureDescription}>
                覚えたい単語を登録して、効率的に復習。<br />
                クイズ形式の出題も用意されていて、試験対策にも最適です。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-word.png"
                alt="Wordbook Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 3: Diary */}
          <div className={styles.featureRow}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>韓国語日記でアウトプット</h2>
              <p className={styles.featureDescription}>
                毎日の出来事を韓国語で記録。<br />
                書く習慣をつけることで、語彙力と表現力が飛躍的に向上します。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-diary.png"
                alt="Diary Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 4: Profile (Reverse) */}
          <div className={`${styles.featureRow} ${styles.reverse}`}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>学習の記録を可視化</h2>
              <p className={styles.featureDescription}>
                日々の達成度をグラフで確認。<br />
                成長を実感できるから、モチベーションが続きます。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-profile.png"
                alt="Profile Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 5: Instant Composition */}
          <div className={styles.featureRow}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>瞬間作文で会話力UP</h2>
              <p className={styles.featureDescription}>
                日本語を見て瞬時に韓国語で表現するトレーニング。<br />
                実際の会話で使える表現力と反射速度を鍛えます。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-composition.png"
                alt="Instant Composition Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 6: Sino-Korean Quiz (Reverse) */}
          <div className={`${styles.featureRow} ${styles.reverse}`}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>漢字語クイズで語彙力強化</h2>
              <p className={styles.featureDescription}>
                韓国語の約60%を占める漢字語をマスター。<br />
                漢字の知識を活かして、効率よく語彙を増やせます。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-hanja-quiz.png"
                alt="Sino-Korean Quiz Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>

          {/* Feature 7: Grammar Dictionary */}
          <div className={styles.featureRow}>
            <div className={styles.featureText}>
              <h2 className={styles.featureTitle}>文法辞典でいつでも確認</h2>
              <p className={styles.featureDescription}>
                韓国語の文法を体系的に整理した辞典機能。<br />
                初級から上級まで、必要な文法をすぐに検索・確認できます。
              </p>
            </div>
            <div className={styles.featureImageWrapper}>
              <Image
                src="/screen/screen-grammar.png"
                alt="Grammar Dictionary Screen"
                width={600}
                height={400}
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          </div>
        </section>

        {/* Footer */}
        <footer className={styles.footer}>
          <div className={styles.footerLinks}>
            <a href="/terms" className={styles.footerLink}>利用規約</a>
            <a href="/privacy" className={styles.footerLink}>プライバシーポリシー</a>
            <a href="/contact" className={styles.footerLink}>お問い合わせ</a>
          </div>
          <div className={styles.socialLinks}>
            <a href="https://suzuri.jp/chaletta" className={styles.socialLink} target="_blank" rel="noopener noreferrer" aria-label="SUZURI">
              SUZURI
            </a>
            <a href="https://line.me/ti/g2/KdC21UZy7vDWwG0stTGvSgBqUN6DRbqGLjeRQQ?utm_source=invitation&utm_medium=link_copy&utm_campaign=default" className={styles.socialLink} target="_blank" rel="noopener noreferrer" aria-label="LINEオープンチャット">
              <SiLine size={20} />
            </a>
            <a href="https://www.instagram.com/chaletta.app?igsh=YTB6OG85Y3l1NGR5&utm_source=ig_contact_invite" className={styles.socialLink} target="_blank" rel="noopener noreferrer" aria-label="Instagram">
              <FaInstagram size={20} />
            </a>
            <a href="https://www.tiktok.com/@chaletta.app" className={styles.socialLink} target="_blank" rel="noopener noreferrer" aria-label="TikTok">
              <FaTiktok size={20} />
            </a>
            <a href="https://x.com/chaletta2026" className={styles.socialLink} target="_blank" rel="noopener noreferrer" aria-label="X">
              <FaXTwitter size={20} />
            </a>
          </div>
          <p className={styles.copyright}>&copy; 2025 Chaletta. All rights reserved.</p>
        </footer>
      </main>
    </div>
  );
}
