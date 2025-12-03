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
                                登録希望者が当社の定める方法によって利用登録を申請し、当社がこれを承認することによって、利用登録が完了するものとします。利用登録は、メールアドレスによる登録、またはソーシャルログイン（Google、Apple、Xなどの外部サービスを利用した登録）により行うことができます。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第3条（ソーシャルログイン）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                1. ユーザーは、Google、Apple、Xなどの外部サービス（以下「外部サービス」といいます）のアカウントを使用して本サービスに登録・ログインすることができます。<br />
                                2. ソーシャルログインを利用する場合、ユーザーは当該外部サービスの利用規約およびプライバシーポリシーに同意したものとみなされます。<br />
                                3. 外部サービスの利用に関して生じた問題については、ユーザーと当該外部サービス提供者との間で解決するものとし、当社は一切の責任を負いません。<br />
                                4. 外部サービスの仕様変更、サービス停止等により、ソーシャルログイン機能が利用できなくなる場合があります。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第4条（ユーザーIDおよびパスワードの管理）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                ユーザーは、自己の責任において、本サービスのユーザーIDおよびパスワードを適切に管理するものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第5条（禁止事項）</h2>
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
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第6条（ユーザー生成コンテンツ）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                1. ユーザーは、本サービス上で投稿、送信、公開するコンテンツ（テキスト、画像、その他の素材を含みます。以下「ユーザーコンテンツ」といいます）について、自らが責任を負うものとします。<br />
                                2. 当社は、ユーザーコンテンツに対する所有権を主張しませんが、本サービスの運営、改善、プロモーションのためにユーザーコンテンツを使用する権利を有するものとします。<br />
                                3. ユーザーは、自らが投稿するコンテンツについて、第三者の権利を侵害していないことを保証するものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第7条（禁止コンテンツ）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、不適切なコンテンツおよび悪質なユーザーに対して一切の寛容を示しません。以下のコンテンツの投稿、共有、送信は固く禁じられています。<br /><br />
                                1. <strong>暴力的・攻撃的なコンテンツ：</strong>暴力を助長、賛美、または描写するコンテンツ、脅迫、いじめ、ハラスメント<br />
                                2. <strong>差別的なコンテンツ：</strong>人種、民族、国籍、宗教、性別、性的指向、障害、その他の特性に基づく差別、ヘイトスピーチ<br />
                                3. <strong>性的に不適切なコンテンツ：</strong>ポルノグラフィー、性的に露骨なコンテンツ、未成年者に関連する不適切なコンテンツ<br />
                                4. <strong>違法なコンテンツ：</strong>違法行為を助長または促進するコンテンツ、著作権・商標権を侵害するコンテンツ<br />
                                5. <strong>詐欺・誤情報：</strong>虚偽の情報、詐欺的なコンテンツ、なりすまし<br />
                                6. <strong>スパム・悪意のあるコンテンツ：</strong>未承諾の広告、マルウェア、フィッシング<br />
                                7. <strong>プライバシー侵害：</strong>他者の個人情報を無断で公開すること<br />
                                8. <strong>その他の有害なコンテンツ：</strong>自傷行為や自殺を助長するコンテンツ、危険な行為を促すコンテンツ
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第8条（コンテンツのモデレーション）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                1. 当社は、本規約に違反するコンテンツを監視、審査、削除する権利を有します。<br />
                                2. ユーザーは、不適切なコンテンツや悪質なユーザーを発見した場合、アプリ内の報告機能を通じて当社に報告することができます。<br />
                                3. 当社は、報告されたコンテンツを審査し、必要に応じて適切な措置を講じます。<br />
                                4. ユーザーは、24時間以内に報告に対応することを目標としますが、対応時間は保証されません。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第9条（違反者への措置）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、本規約に違反したユーザーに対し、以下の措置を講じることができます。<br /><br />
                                1. <strong>警告：</strong>軽微な違反に対して警告を発し、問題のコンテンツの削除を求めます。<br />
                                2. <strong>コンテンツの削除：</strong>違反コンテンツを予告なく削除します。<br />
                                3. <strong>一時的な利用停止：</strong>繰り返しの違反または重大な違反に対して、一定期間アカウントを停止します。<br />
                                4. <strong>永久的なアカウント削除：</strong>重大な違反、繰り返しの違反、または悪質な行為に対して、アカウントを永久に削除します。<br /><br />
                                当社は、違反の重大性、頻度、および状況に応じて、上記の措置を単独または組み合わせて適用する裁量権を有します。措置に対する異議申し立ては、当社の定める方法により行うことができます。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第10条（ユーザーの責任と協力）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                1. ユーザーは、本サービスを安全で健全なコミュニティとして維持するために協力することに同意します。<br />
                                2. ユーザーは、不適切なコンテンツや悪質なユーザーを発見した場合、速やかに報告することが推奨されます。<br />
                                3. ユーザーは、他のユーザーを尊重し、建設的なコミュニケーションを心がけることに同意します。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第11条（本サービスの提供の停止等）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、以下のいずれかの事由があると判断した場合、ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。<br />
                                1. 本サービスにかかるコンピュータシステムの保守点検または更新を行う場合<br />
                                2. 地震、落雷、火災、停電または天災などの不可抗力により、本サービスの提供が困難となった場合<br />
                                3. コンピュータまたは通信回線等が事故により停止した場合<br />
                                4. その他、当社が本サービスの提供が困難と判断した場合
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第12条（免責事項）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社の債務不履行責任は、当社の故意または重過失によらない場合には免責されるものとします。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第13条（サービス内容の変更等）</h2>
                            <p style={{ lineHeight: "1.8", color: "var(--muted-foreground)" }}>
                                当社は、ユーザーに通知することなく、本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし、これによってユーザーに生じた損害について一切の責任を負いません。
                            </p>
                        </section>

                        <section>
                            <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1rem" }}>第14条（利用規約の変更）</h2>
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
