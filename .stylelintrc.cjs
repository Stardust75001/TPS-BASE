<<<<<<< HEAD
/* Stylelint v16 – profil Shopify allégé (utile en CI) */
module.exports = {
  extends: ["stylelint-config-standard", "stylelint-config-standard-scss"],
=======
/* Stylelint v16 (profil Shopify, tolérant pour migration) */
module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss",
  ],
>>>>>>> 41dc94e (stylelint: v16 soft config (migration sans plugin legacy))
  plugins: ["stylelint-order"],
  reportInvalidScopeDisables: false,
  rules: {
<<<<<<< HEAD
    // Allégement et essentiels
    "order/properties-alphabetical-order": null,
    "custom-property-empty-line-before": null,
    "selector-attribute-quotes": null,
    "value-no-vendor-prefix": null,
    "no-empty-source": true,
    "block-no-empty": true,
    "declaration-block-no-duplicate-properties": true,

    // Déactivations pour calmer le bruit
    "no-duplicate-selectors": null,
    "no-descending-specificity": null,
    "selector-class-pattern": null,
    "property-no-vendor-prefix": null,
    "value-keyword-case": null,
    "color-hex-length": "short",
    "keyframes-name-pattern": null,
    "property-no-unknown": null,
    "declaration-property-value-no-unknown": null,
    "color-function-alias-notation": null,
    "color-function-notation": null,
    "alpha-value-notation": null,
    "media-feature-range-notation": null,
    "media-feature-name-value-no-unknown": null,
    "selector-not-notation": null,
    "property-no-deprecated": null,
    "comment-empty-line-before": null,
    "rule-empty-line-before": null,
    "declaration-empty-line-before": null,
    "at-rule-empty-line-before": null,
    "comment-whitespace-inside": null,
    "length-zero-no-unit": null,
    "shorthand-property-no-redundant-values": null,
    "declaration-block-no-redundant-longhand-properties": null,
    "selector-pseudo-element-colon-notation": null,
=======
    /* migration: évite un diff monstrueux lié aux rgba() et aux % */
    "color-function-notation": null,           // autorise rgba()
    "alpha-value-notation": "number",          // 0.5 au lieu de 50%

    /* ordre des propriétés : on garde, mais tu pourras le durcir plus tard */
    "order/properties-alphabetical-order": true,

    /* noms de classes kebab-case (utile sur un thème Shopify) */
    "selector-class-pattern": [
      "^[a-z0-9\\-]+$",
      { message: "Utilise des classes en kebab-case (a-z0-9-)." }
    ],

    /* évite une pluie d’alertes pendant la migration */
    "no-descending-specificity": null,
    "property-no-vendor-prefix": null,
    "value-no-vendor-prefix": null,
    "selector-pseudo-element-colon-notation": "double", // ::before, ::after
>>>>>>> 41dc94e (stylelint: v16 soft config (migration sans plugin legacy))
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
<<<<<<< HEAD
    "**/*.min.css",
    "assets/vendor-*.css",
    "assets/*.min.css",
  ],
=======
    "**/*.min.css"
  ],
  overrides: [
    /* on est encore plus permissif sur assets/ pendant la migration */
    {
      files: ["assets/**/*.css", "assets/**/*.scss"],
      rules: {
        "order/properties-alphabetical-order": null
      }
    }
  ]
>>>>>>> 41dc94e (stylelint: v16 soft config (migration sans plugin legacy))
};
