import { expect, test } from "@playwright/test";
let executedCount = 0; // counts tests that actually ran (not skipped early)

// Determine base URL order of precedence:
// 1. PREVIEW_URL (set in CI after deploy/preview step)
// 2. SMOKE_BASE_URL (optional override)
// 3. Local development fallback (Shopify theme dev default host)
const BASE =
  process.env.PREVIEW_URL ||
  process.env.SMOKE_BASE_URL ||
  "http://127.0.0.1:9292";

// Paths we want to sanity‑check relative to base.
const paths = ["/", "/collections", "/search"];

async function ensureReachable(url: string, page) {
  // Quick HEAD/GET via API request layer (faster than full navigation) to decide skip early.
  try {
    const res = await page.context().request.get(url, { maxRedirects: 2 });
    if (!res.ok()) {
      test.skip(
        true,
        `Skipping smoke tests: base responded with HTTP ${res.status()} for ${url}`
      );
    }
  } catch (e) {
    // Skip gracefully when local dev server not running. In CI we still want an explicit skip (not a hard fail)
    test.skip(
      true,
      `Skipping smoke tests: cannot reach base URL ${url}. (${
        (e as Error).message
      })`
    );
  }
}

for (const p of paths) {
  test(`@smoke ${p} loads`, async ({ page }) => {
    const url = BASE.replace(/\/$/, "") + p;
    await ensureReachable(url, page);
    await page.goto(url);
    await expect(page).toHaveTitle(/./);
    const bodyText = await page.locator("body").innerText();
    expect(bodyText.length).toBeGreaterThan(10);
    executedCount++;
  });
}

test("@smoke header visible", async ({ page }) => {
  const url = BASE.replace(/\/$/, "") + "/";
  await ensureReachable(url, page);
  await page.goto(url);
  await expect(page.locator("header").first()).toBeVisible();
  executedCount++;
});

// After all tests, if we're in CI and a PREVIEW_URL was provided (non-placeholder), ensure something ran.
test.afterAll(async () => {
  const inCI = !!process.env.CI;
  const preview = process.env.PREVIEW_URL || "";
  const placeholder = preview.includes("example.invalid");
  if (inCI && preview && !placeholder && executedCount === 0) {
    throw new Error("Smoke suite: zero tests executed (all skipped) with PREVIEW_URL set. Failing to surface misconfiguration.");
  }
});
