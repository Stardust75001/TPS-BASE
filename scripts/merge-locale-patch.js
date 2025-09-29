// Non-destructive deep merge of patch into target locale file
// Usage: node scripts/merge-locale-patch.js <target-locale.json> <patch.json>
const fs = require("fs");
const path = require("path");

function deepMerge(target, patch) {
  for (const key in patch) {
    if (
      typeof patch[key] === "object" &&
      patch[key] !== null &&
      !Array.isArray(patch[key]) &&
      typeof target[key] === "object" &&
      target[key] !== null &&
      !Array.isArray(target[key])
    ) {
      deepMerge(target[key], patch[key]);
    } else if (target[key] === undefined) {
      target[key] = patch[key];
    }
    // If target[key] exists, do not overwrite
  }
}

function main() {
  const [, , targetPath, patchPath] = process.argv;
  if (!targetPath || !patchPath) {
    console.error(
      "Usage: node scripts/merge-locale-patch.js <target-locale.json> <patch.json>"
    );
    process.exit(1);
  }
  const target = JSON.parse(fs.readFileSync(targetPath, "utf8"));
  const patch = JSON.parse(fs.readFileSync(patchPath, "utf8"));
  deepMerge(target, patch);
  fs.writeFileSync(targetPath, JSON.stringify(target, null, 2), "utf8");
  console.log(`Patch merged into ${targetPath}`);
}

if (require.main === module) {
  main();
}
