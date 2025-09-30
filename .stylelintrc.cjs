module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss"
  ],
  plugins: [
    "stylelint-order",
    "stylelint-no-unsupported-browser-features"
  ],
  rules: {
    /* Désactivation / assouplissement pour calmer les faux positifs */
    "order/properties-alphabetical-order": null,
    "custom-property-empty-line-before": null,
    "selector-attribute-quotes": null,
    "value-no-vendor-prefix": null,
    "property-no-vendor-prefix": null,
    "no-descending-specificity": null,
    "no-duplicate-selectors": null,

    /* Garde les basiques de qualité */
    "no-empty-source": true,
    "block-no-empty": true,
    "declaration-block-no-duplicate-properties": true,
    "color-hex-length": "short",

    /* Désactive la casse forcée sur mots-clés */
    "value-keyword-case": null,

    /* Plugin compatibilité navigateurs */
    "plugin/no-unsupported-browser-features": [true, {
      severity: "warning",
      ignorePartialSupport: true
    }]
  }
};
