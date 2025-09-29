// translate-locales.js
// Auto-translates en.default.json to de.json and fr.json using Google Translate API
// Run: node translate-locales.js
// Requires: npm install @google-cloud/translate

const fs = require("fs");
const path = require("path");
const { Translate } = require("@google-cloud/translate").v2;

// Set your Google Cloud Translate API key here
const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY || "YOUR_API_KEY";
const translate = new Translate({ key: GOOGLE_API_KEY });

const srcFile = path.join(__dirname, "locales", "en.default.json");
const targets = [
  { lang: "de", file: path.join(__dirname, "locales", "de.json") },
  { lang: "fr", file: path.join(__dirname, "locales", "fr.json") },
];

async function translateObject(obj, lang) {
  if (typeof obj === "string") {
    const [translation] = await translate.translate(obj, lang);
    return translation;
  } else if (Array.isArray(obj)) {
    return Promise.all(obj.map((item) => translateObject(item, lang)));
  } else if (typeof obj === "object" && obj !== null) {
    const result = {};
    for (const key in obj) {
      result[key] = await translateObject(obj[key], lang);
    }
    return result;
  }
  return obj;
}

async function run() {
  if (!fs.existsSync(srcFile)) {
    console.error("Source file not found:", srcFile);
    process.exit(1);
  }
  const srcJson = JSON.parse(fs.readFileSync(srcFile, "utf8"));
  for (const { lang, file } of targets) {
    console.log(`Translating to ${lang}...`);
    const translated = await translateObject(srcJson, lang);
    fs.writeFileSync(file, JSON.stringify(translated, null, 2));
    console.log(`Written: ${file}`);
  }
  console.log("Translation complete.");
}

run().catch((err) => {
  console.error("Translation error:", err);
  process.exit(1);
});
