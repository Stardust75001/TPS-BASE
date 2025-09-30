/* Stylelint v16 – config Shopify allégée et corrigée */
module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss",
  ],
  plugins: ["stylelint-order"],
  reportInvalidScopeDisables: false,
  rules: {
    /* Ordonancement & lisibilité */
    "order/properties-alphabetical-order": null,   // évite tsunami d’ordonnancement
    "custom-property-empty-line-before": null,     // évite sauts de ligne forcés
    "selector-attribute-quotes": null,             // autorise [data-attr=true] sans ""
    "value-no-vendor-prefix": null,                // autorise -webkit-… si besoin

    /* De base */
    "no-empty-source": true,
    "block-no-empty": true,
    "declaration-block-no-duplicate-properties": true,

    /* Désactivées pour compat Shopify */
    "no-duplicate-selectors": null,
    "no-descending-specificity": null,
    "selector-class-pattern": null,
    "property-no-vendor-prefix": null,
    "value-keyword-case": null,
    "color-hex-length": "short",

    /* Allégées pour CI */
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
    "selector-pseudo-element-colon-notation": null
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
    "**/*.min.css"
  ]
};
