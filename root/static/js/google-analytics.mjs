const gtag_id = 'G-E82Q2V8LVD';

window.dataLayer = window.dataLayer || [];
const gtag = function () {
    window.dataLayer.push(arguments);
};

const ga = document.createElement('script');
ga.src =  `https://www.googletagmanager.com/gtag/js?id=${ gtag_id }`;
ga.async = true;
document.head.appendChild(ga);

gtag('js', new Date());
gtag('config', gtag_id, {
    cookie_flags: 'SameSite=Lax;Secure',
});

export {
    gtag,
    gtag as
    default,
};
