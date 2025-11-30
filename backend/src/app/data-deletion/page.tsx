import styles from "../page.module.css";

export default function DataDeletion() {
    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <div style={{ maxWidth: "800px", padding: "4rem 2rem", width: "100%" }}>
                    <h1 className={styles.title} style={{ fontSize: "2.5rem", marginBottom: "2rem" }}>ユーザーデータ削除手順</h1>

                    <div style={{ display: "flex", flexDirection: "column", gap: "2rem", color: "var(--foreground)" }}>
                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>データ削除について</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                チャレッタアプリでは、ユーザーご自身でアカウントおよび関連するすべてのデータを削除することができます。
                                以下の手順に従って、データ削除を行ってください。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>削除手順</h2>
                            <div style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                <p style={{ marginBottom: "1rem" }}>
                                    <strong>ステップ1:</strong> チャレッタアプリを開きます。
                                </p>
                                <p style={{ marginBottom: "1rem" }}>
                                    <strong>ステップ2:</strong> プロフィールページに移動します。
                                </p>
                                <p style={{ marginBottom: "1rem" }}>
                                    <strong>ステップ3:</strong> 「アカウント削除」ボタンをタップします。
                                </p>
                                <p style={{ marginBottom: "1rem" }}>
                                    <strong>ステップ4:</strong> 確認画面で削除を承認します。
                                </p>
                            </div>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>削除されるデータ</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                アカウント削除を実行すると、以下のデータがすべて削除されます：
                            </p>
                            <ul style={{ lineHeight: "1.8", color: "var(--muted-foreground)", marginTop: "1rem", paddingLeft: "1.5rem" }}>
                                <li>ユーザープロフィール情報</li>
                                <li>学習履歴・進捗データ</li>
                                <li>投稿したコンテンツ</li>
                                <li>その他アカウントに紐づくすべての情報</li>
                            </ul>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>注意事項</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                一度削除されたデータは復元できません。削除を実行する前に、必要なデータがないことをご確認ください。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>お問い合わせ</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                データ削除に関してご不明な点がございましたら、下記までお問い合わせください。<br />
                                <br />
                                Eメールアドレス：support@example.com
                            </p>
                        </section>
                    </div>

                    <div style={{ marginTop: "4rem", textAlign: "center" }}>
                        <a href="/" className={styles.ctaButton} style={{ textDecoration: "none" }}>
                            トップページに戻る
                        </a>
                    </div>
                </div>
            </main>
        </div>
    );
}
