import styles from "../page.module.css";

export default function AuthError() {
    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <div style={{ maxWidth: "600px", padding: "4rem 2rem", width: "100%", textAlign: "center" }}>
                    <div style={{ fontSize: "4rem", marginBottom: "1.5rem" }}>!</div>

                    <h1 className={styles.title} style={{ fontSize: "2rem", marginBottom: "1.5rem" }}>
                        認証エラーが発生しました
                    </h1>

                    <p style={{
                        lineHeight: "1.8",
                        color: "var(--muted-foreground)",
                        marginBottom: "2rem"
                    }}>
                        ログイン処理中にエラーが発生しました。<br />
                        お手数ですが、再度お試しください。
                    </p>

                    <div style={{
                        display: "flex",
                        flexDirection: "column",
                        gap: "1.5rem",
                        color: "var(--foreground)",
                        textAlign: "left",
                        marginTop: "2rem"
                    }}>
                        <section>
                            <h2 style={{ fontSize: "1.25rem", fontWeight: "bold", marginBottom: "0.75rem" }}>
                                解決方法
                            </h2>
                            <ul style={{
                                lineHeight: "1.8",
                                color: "var(--muted-foreground)",
                                paddingLeft: "1.5rem"
                            }}>
                                <li>アプリを再起動して、もう一度ログインをお試しください</li>
                                <li>インターネット接続を確認してください</li>
                                <li>問題が解決しない場合は、しばらく時間をおいてから再度お試しください</li>
                            </ul>
                        </section>
                    </div>
                </div>
            </main>
        </div>
    );
}
