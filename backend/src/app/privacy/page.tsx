import styles from "../page.module.css";

export default function Privacy() {
    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <div style={{ maxWidth: "800px", padding: "4rem 2rem", width: "100%" }}>
                    <h1 className={styles.title} style={{ fontSize: "2.5rem", marginBottom: "2rem" }}>プライバシーポリシー</h1>

                    <div style={{ display: "flex", flexDirection: "column", gap: "2rem", color: "var(--foreground)" }}>
                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第1条（個人情報）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                「個人情報」とは、個人情報保護法にいう「個人情報」を指すものとし、生存する個人に関する情報であって、当該情報に含まれる氏名、生年月日、住所、電話番号、連絡先その他の記述等により特定の個人を識別できる情報及び容貌、指紋、声紋にかかるデータ、及び健康保険証の保険者番号などの当該情報単体から特定の個人を識別できる情報（個人識別情報）を指します。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第2条（個人情報の収集方法）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、ユーザーが利用登録をする際に氏名、生年月日、住所、電話番号、メールアドレス、銀行口座番号、クレジットカード番号などの個人情報をお尋ねすることがあります。また、ユーザーと提携先などとの間でなされたユーザーの個人情報を含む取引記録や決済に関する情報を、当社の提携先（情報提供元、広告主、広告配信先などを含みます。以下、｢提携先｣といいます。）などから収集することがあります。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第3条（ソーシャルログインによる情報取得）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、ユーザーがソーシャルログイン機能（Google、Apple、Xなどの外部サービスを利用したログイン）を使用して本サービスに登録・ログインする場合、当該外部サービスから以下の情報を取得することがあります。<br />
                                <br />
                                1. メールアドレス<br />
                                2. 氏名または表示名<br />
                                3. プロフィール画像<br />
                                4. 外部サービスにおけるユーザーID<br />
                                <br />
                                これらの情報は、本サービスにおけるアカウントの作成・認証、およびユーザー体験の向上のために使用されます。当社は、認証サービスとしてAuth0を利用しており、ユーザーの認証情報はAuth0のセキュリティ基準に従って安全に管理されます。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第4条（個人情報を収集・利用する目的）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社が個人情報を収集・利用する目的は、以下のとおりです。<br />
                                1. 当社サービスの提供・運営のため<br />
                                2. ユーザーからのお問い合わせに回答するため（本人確認を行うことを含む）<br />
                                3. ユーザーが利用中のサービスの新機能、更新情報、キャンペーン等及び当社が提供する他のサービスの案内のメールを送付するため<br />
                                4. メンテナンス、重要なお知らせなど必要に応じたご連絡のため<br />
                                5. 利用規約に違反したユーザーや、不正・不当な目的でサービスを利用しようとするユーザーの特定をし、ご利用をお断りするため<br />
                                6. ユーザーにご自身の登録情報の閲覧や変更、削除、ご利用状況の閲覧を行っていただくため<br />
                                7. 上記の利用目的に付随する目的
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第5条（利用目的の変更）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、利用目的が変更前と関連性を有すると合理的に認められる場合に限り、個人情報の利用目的を変更するものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第6条（個人情報の第三者提供）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、次に掲げる場合を除いて、あらかじめユーザーの同意を得ることなく、第三者に個人情報を提供することはありません。ただし、個人情報保護法その他の法令で認められる場合を除きます。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第7条（個人情報の開示）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、本人から個人情報の開示を求められたときは、本人に対し、遅滞なくこれを開示します。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第8条（お問い合わせ窓口）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                本ポリシーに関するお問い合わせは、下記の窓口までお願いいたします。<br />
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
