import React from 'react';

export default function ContactPage() {
    return (
        <div style={{
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            minHeight: '100vh',
            padding: '20px',
            backgroundColor: '#f8f9fa'
        }}>
            <iframe
                src="https://docs.google.com/forms/d/e/1FAIpQLSezUZkcHAmwgElzxeF8UF1axcokIWEiHzcfrF_IVlXcZHbsmg/viewform?embedded=true"
                width="640"
                height="748"
                style={{ border: 'none', maxWidth: '100%' }}
                title="Contact Form"
            >
                読み込んでいます…
            </iframe>
        </div>
    );
}
