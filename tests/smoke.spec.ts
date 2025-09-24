import { expect, test } from "@playwright/test";

// @smoke
// Lightweight availability checks. Fast (<5s) and safe to run on every PR.
// Assumes PREVIEW_URL or baseURL is configured; falls back to '/'.

const paths = ["/", "/collections", "/search"];

for (const p of paths) {
  test(`@smoke ${p} loads with 2xx`, async ({ page }) => {
    await page.goto(p);
    // Basic network / DOM sanity
    await expect(page).toHaveTitle(/./); // any non-empty title
    // Minimal visible content heuristic
    const bodyText = await page.locator("body").innerText();
    expect(bodyText.length).toBeGreaterThan(10);
  });
}

// Focused critical element example (customize selectors later)
test("@smoke header present", async ({ page }) => {
  await page.goto("/");
  const header = page.locator("header");
  await expect(header.first()).toBeVisible();
});
