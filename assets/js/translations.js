// Default language
let currentLanguage = 'en';

// Function to load translations
async function loadTranslations(lang) {
    try {
        const response = await fetch(`/translations/${lang}.json`);
        if (!response.ok) throw new Error('Failed to load translations');
        return response.json();
    } catch (error) {
        console.error('Error loading translations:', error);
        return {};
    }
}

// Function to translate placeholders
function translatePlaceholders(translations) {
    document.querySelectorAll('[data-i18n-placeholder]').forEach(element => {
        const key = element.getAttribute('data-i18n-placeholder');
        if (translations[key]) {
            element.placeholder = translations[key];
        }
    });
}

// Function to change language
async function changeLanguage(lang) {
    const allowedLanguages = ['en', 'it'];
    if (!allowedLanguages.includes(lang)) {
        lang = 'en';
    }
    currentLanguage = lang;
    const translations = await loadTranslations(lang);
    document.querySelectorAll('[data-i18n]').forEach(element => {
        const key = element.getAttribute('data-i18n');
        if (translations[key]) {
            element.textContent = translations[key];
        }
    });
    translatePlaceholders(translations);
    document.documentElement.lang = lang;
    // Save the language preference
    localStorage.setItem('preferredLanguage', lang);
}

// Function to detect browser language
function detectBrowserLanguage() {
    const browserLang = navigator.language || navigator.languages[0];
    return browserLang.startsWith('it') ? 'it' : 'en';
}

// Load the preferred language on page load
window.addEventListener('DOMContentLoaded', () => {
    // Check for saved language preference
    const savedLanguage = localStorage.getItem('preferredLanguage');
    if (savedLanguage) {
        changeLanguage(savedLanguage);
    } else {
        // Detect browser language
        const browserLanguage = detectBrowserLanguage();
        changeLanguage(browserLanguage);
    }
});

