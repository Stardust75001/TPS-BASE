/* Stylelint v16 – Config Shopify */
module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss",
  ],
  plugins: ["stylelint-order"],
  rules: {
    "order/properties-alphabetical-order": true,
    "selector-class-pattern": [
      "^[a-z0-9\\-]+$",
      { message: "Utilise des classes en kebab-case (a-z0-9-)." }
    ],
    "no-duplicate-selectors": true,
    "declaration-block-no-duplicate-properties": true,

    /* assouplissements utiles */
    "color-function-alias-notation": null,
    "color-function-notation": null,
    "alpha-value-notation": null,
    "value-keyword-case": null,
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
    "keyframes-name-pattern": null,
    "selector-pseudo-element-colon-notation": null,
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
    "**/*.min.css",
  ],
};
