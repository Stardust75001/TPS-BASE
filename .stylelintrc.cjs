/* Stylelint v16 */
module.exports = {
  extends: [
    "stylelint-config-standard",
    "stylelint-config-standard-scss"
  ],
  plugins: ["stylelint-order"],
  rules: {
    "order/properties-alphabetical-order": true,
    "color-hex-length": "short",
    "selector-class-pattern": [
      "^[a-z0-9\\-]+$",
      { message: "Utilise des classes en kebab-case (a-z0-9-)." }
    ]
  },
  ignoreFiles: [
    "**/dist/**",
    "**/build/**",
    "**/vendor/**",
    "**/*.min.css"
  ]
};
