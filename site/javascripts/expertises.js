// Expertises : choix d'une entrée sans saut de défilement.
// Sans JavaScript, le composant fonctionne en CSS seul (:target), au prix d'un saut vers le panneau.
// Avec ce script, la classe .vt-js bascule le CSS sur .is-current / aria-current, et l'URL est mise
// à jour par history.replaceState (lien partageable, aucun défilement, pas d'entrée d'historique).
(function () {
  "use strict";

  function select(box, hash) {
    var items = box.querySelectorAll("a.vt-exp-item");
    var panels = box.querySelectorAll(".vt-exp-panel");
    var index = 0;
    items.forEach(function (a, i) { if (a.hash === hash) index = i; });
    items.forEach(function (a, i) {
      if (i === index) a.setAttribute("aria-current", "true");
      else a.removeAttribute("aria-current");
    });
    panels.forEach(function (p, i) { p.classList.toggle("is-current", i === index); });
  }

  function init() {
    document.querySelectorAll(".vt-expertises").forEach(function (box) {
      box.classList.add("vt-js");
      select(box, window.location.hash);
      box.addEventListener("click", function (event) {
        var link = event.target.closest("a.vt-exp-item");
        if (!link || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
        event.preventDefault();
        history.replaceState(null, "", link.hash);
        select(box, link.hash);
      });
    });
  }

  window.addEventListener("hashchange", function () {
    document.querySelectorAll(".vt-expertises.vt-js").forEach(function (box) { select(box, window.location.hash); });
  });
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
  else init();
})();
