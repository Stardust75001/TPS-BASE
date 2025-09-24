# Theme Runtime Conventions (Hybrid Loader & Media Lazy Strategies)

This document summarizes the loading, security, and performance patterns introduced in the theme so future changes remain consistent and safe.

## 1. Hybrid Script Loader Pattern

We replaced direct `<script src>` tags for theme-owned assets with a guarded hybrid system that:

- Accepts declarative JSON/placeholder script tags: `<script type="application/json" data-hybrid-src="..." data-hybrid-mode="auto">`.
- Chooses between native `<script>` injection or `fetch + eval` based on MIME, size, and safety checks.
- Rejects HTML payload masquerading as JavaScript (mitigates nosniff console noise & execution hazards).
- Adds timeout + newline padding for deterministic source mapping.
- Provides performance marks around each load.

### Authoring Rules

- Use `data-hybrid-src` for any remote or internal script that is *not* critical to First Paint.
- Preserve `data-hybrid-mode="auto"` unless you explicitly need `script` (force native tag) or `fetch` (force fetch/eval path).
- Security: Avoid adding new raw `<script src>` in Liquid. If absolutely required, annotate with `{% comment %} justified raw script {% endcomment %}` and consider adding a validator exception.

## 2. Remote Asset Handling

Remote third‑party scripts (example: tracking / analytics) are wrapped in hybrid tags instead of direct `<script src>`:

```liquid
<script type="application/json"
  data-hybrid-src="https://example.com/library.js"
  data-hybrid-mode="auto"
  data-hybrid-timeout="8000"
  data-hybrid-crossorigin="anonymous"></script>
```

Benefits: Theme Check RemoteAsset rule compliance, deferred execution, potential batching.

## 3. Lazy Iframe Strategy

Embedded YouTube / Vimeo / product media iframes are now authored with `data-src` and class `js-lazy-iframe`:

```html
<iframe class="hero-video js-lazy-iframe" data-src="https://www.youtube.com/embed/ID?..." loading="lazy"></iframe>
```

A small initializer (`assets/lazy-iframe-init.js`) swaps `data-src` → `src` when near viewport using IntersectionObserver with a `rootMargin` of 120px.

### Guidelines

- Always include `title` and minimal `allow` attributes.
- Provide a `<noscript>` fallback if the iframe carries essential content.
- Reuse `js-lazy-iframe`; do not duplicate logic.

## 4. Image Dimension Policy

Every rendered `<img>` must include explicit `width` and `height` (intrinsic or computed):

- If using Shopify `image_url` with a fixed width, compute height via `width / aspect_ratio`.
- For decorative icons (social / flags) use fixed pixel sizes ≤ 48px.
- Placeholder SVG tags are exempt.

## 5. Undefined Variable Seeding

Sections that dynamically compose Bootstrap row / spacing classes pre-seed variables via a consolidated `{% liquid %}` block to avoid Theme Check `UndefinedObject` noise:

```liquid
{% liquid
  assign row_xs = row_xs | default: ''
  assign pt = pt | default: ''
%}
```

Do not scatter `assign` statements inline after markup begins—keep them grouped at the top.

## 6. content_for_header Refactor

The Shogun integration was modified to aggregate mutations into a single final capture:

- Accumulates into `__cfh`.
- Writes back once: `{% capture content_for_header %}{{ __cfh }}{% endcapture %}`.

This pattern prevents multiple direct `content_for_header` rewrites that previously triggered lint warnings.

## 7. Performance Ordering Recommendations

(Partially applied—use for future adjustments)

- Keep critical CSS early; defer non-critical JS with `defer` or hybrid loader.
- Maintain existing `preconnect` for `cdn.shopify.com` and `fonts.shopifycdn.com` before any font or Shopify asset usage.
- Consider adding `rel="preload" as="image"` for the above-the-fold hero image on index if *largest contentful paint* remains high after Lighthouse review.
- Avoid `async` for scripts that rely on execution ordering among themselves; use `defer` + hybrid gating.

## 8. When Adding New Third-Party Integrations

1. Prefer server-side (Shopify app) integration before client script.
2. If client script unavoidable:
   - Use hybrid tag.
   - Scope globals under a namespace (`window.AppVendor = ...`).
   - Add integrity or at minimum version pin in a comment.
3. Document purpose and data collection considerations (GDPR/consent) near the tag.

## 9. Validation / Guard Rails

A repository validator exists (hybrid validator) to block reintroduction of raw theme asset `<script src>`. Keep it updated if new allowed assets are added.

## 10. Maintenance Checklist (Quarterly)

- Run `theme-check` (expect zero baseline errors).
- Audit for new external `<script src>` or un-dimensioned images.
- Confirm loader still rejects HTML masquerading as JS when upstream platform changes headers.
- Re-run Lighthouse (mobile) for LCP & CLS.

---

**Last Updated:** {{ 'now' | date: '%Y-%m-%d' }}
