(function () {
  if (window.__lazyIframeInit) return;
  window.__lazyIframeInit = true;
  function activate(el) {
    if (el.dataset.src && !el.src) {
      el.src = el.dataset.src;
    }
  }
  function onIntersect(entries, obs) {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        activate(e.target);
        obs.unobserve(e.target);
      }
    });
  }
  var iframes = document.querySelectorAll("iframe.js-lazy-iframe[data-src]");
  if ("IntersectionObserver" in window) {
    var io = new IntersectionObserver(onIntersect, { rootMargin: "120px" });
    iframes.forEach((f) => io.observe(f));
  } else {
    iframes.forEach(activate);
  }
})();
