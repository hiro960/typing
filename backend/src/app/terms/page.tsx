import styles from "../page.module.css";

export default function Terms() {
    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <div style={{ maxWidth: "800px", padding: "4rem 2rem", width: "100%" }}>
                    <h1 className={styles.title} style={{ fontSize: "2.5rem", marginBottom: "2rem" }}>利用規約</h1>

                    <div style={{ display: "flex", flexDirection: "column", gap: "2rem", color: "var(--foreground)" }}>
                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第1条（適用）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                本規約は、ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されるものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第2条（利用登録）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                登録希望者が当社の定める方法によって利用登録を申請し、当社がこれを承認することによって、利用登録が完了するものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第3条（ユーザーIDおよびパスワードの管理）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                ユーザーは、自己の責任において、本サービスのユーザーIDおよびパスワードを適切に管理するものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第4条（禁止事項）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                ユーザーは、本サービスの利用にあたり、以下の行為をしてはなりません。<br />
                                1. 法令または公序良俗に違反する行為<br />
                                2. 犯罪行為に関連する行為<br />
                                3. 本サービスの内容等、本サービスに含まれる著作権、商標権ほか知的財産権を侵害する行為<br />
                                4. 当社、ほかのユーザー、またはその他第三者のサーバーまたはネットワークの機能を破壊したり、妨害したりする行為<br />
                                5. その他、当社が不適切と判断する行為
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第5条（本サービスの提供の停止等）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、以下のいずれかの事由があると判断した場合、ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。<br />
                                1. 本サービスにかかるコンピュータシステムの保守点検または更新を行う場合<br />
                                2. 地震、落雷、火災、停電または天災などの不可抗力により、本サービスの提供が困難となった場合<br />
                                3. コンピュータまたは通信回線等が事故により停止した場合<br />
                                4. その他、当社が本サービスの提供が困難と判断した場合
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第6条（免責事項）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社の債務不履行責任は、当社の故意または重過失によらない場合には免責されるものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第7条（サービス内容の変更等）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、ユーザーに通知することなく、本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし、これによってユーザーに生じた損害について一切の責任を負いません。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第8条（利用規約の変更）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、必要と判断した場合には、ユーザーに通知することなくいつでも本規約を変更することができるものとします。
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
