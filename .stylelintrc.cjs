/* Stylelint v16 (profil Shopify, tolérant pour migration) */
module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss",
  ],
  plugins: ["stylelint-order"],
  rules: {
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
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
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
};
