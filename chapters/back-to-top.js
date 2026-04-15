(function () {
  'use strict';

  var button = document.getElementById('back-to-top');
  var masthead = document.querySelector('.masthead');
  var body = document.body;
  var isHeaderVisible = true;

  if (!button || !masthead || !body) return;

  function updateVisibility() {
    var isLexemePanelOpen = body.classList.contains('lex-panel-active');
    var shouldShow = (window.scrollY > 240 || !isHeaderVisible) && !isLexemePanelOpen;
    button.classList.toggle('is-visible', shouldShow);
  }

  button.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  if ('IntersectionObserver' in window) {
    var observer = new IntersectionObserver(function (entries) {
      if (!entries || !entries.length) return;
      isHeaderVisible = entries[0].isIntersecting;
      updateVisibility();
    }, {
      threshold: 0.1
    });

    observer.observe(masthead);
  } else {
    isHeaderVisible = masthead.getBoundingClientRect().bottom > 0;
  }

  window.addEventListener('scroll', updateVisibility, { passive: true });
  window.addEventListener('resize', updateVisibility);

  if ('MutationObserver' in window) {
    var classObserver = new MutationObserver(updateVisibility);
    classObserver.observe(body, { attributes: true, attributeFilter: ['class'] });
  }

  updateVisibility();
})();
