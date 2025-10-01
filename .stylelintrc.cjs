/* Stylelint v16 (profil Shopify, migration-friendly strict config) */
module.exports = {
  extends: ["stylelint-config-standard", "stylelint-config-standard-scss"],
  plugins: ["stylelint-order"],
  reportInvalidScopeDisables: false,
  rules: {
    // Migration: allow rgba(), % alpha, and relax some rules for easier transition
    "color-function-notation": null, // allow rgba()
    "alpha-value-notation": "number", // 0.5 instead of 50%

    // Strict property order (can be hardened later)
    "order/properties-alphabetical-order": true,

    // Enforce kebab-case for class names (Shopify best practice)
    "selector-class-pattern": [
      "^[a-z0-9\\-]+$",
      { message: "Utilise des classes en kebab-case (a-z0-9-)." },
    ],

    // Migration: reduce noise from vendor/legacy code
    "no-descending-specificity": null,
    "property-no-vendor-prefix": null,
    "value-no-vendor-prefix": null,
    "selector-pseudo-element-colon-notation": "double", // ::before, ::after
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
    "**/*.min.css",
    "assets/vendor-*.css", // ex: vendor-bootstrap.min.css, splide, nouislider, etc.
    "assets/*.min.css",
  ],
  overrides: [
    // Be even more permissive in assets/ during migration
    {
      files: ["assets/**/*.css", "assets/**/*.scss"],
      rules: {
        "order/properties-alphabetical-order": null,
      },
    },
  ],
};
