(function () {
  'use strict';

  var crumb = document.getElementById('scroll-crumb');
  var masthead = document.querySelector('.masthead');
  var chapterLink = document.getElementById('scroll-crumb-chapter');
  var sectionLink = document.getElementById('scroll-crumb-section');
  var subWrap = document.getElementById('scroll-crumb-subwrap');
  var subLink = document.getElementById('scroll-crumb-subsection');
  var toggle = document.getElementById('scroll-crumb-toggle');
  var menu = document.getElementById('scroll-crumb-menu');
  var menuLinks = Array.prototype.slice.call(
    document.querySelectorAll('#scroll-crumb-menu a[href^="#"]')
  );
  var sections = Array.prototype.slice.call(
    document.querySelectorAll('.main section[id^="sec-"]')
  );
  var ticking = false;
  var isExpanded = false;

  if (!crumb || !masthead || !chapterLink || !sectionLink || !subWrap || !subLink || !toggle || !menu || !sections.length) {
    return;
  }

  chapterLink.textContent = (
    (document.querySelector('.masthead h1') || {}).textContent || 'Chapter'
  ).trim();
  chapterLink.setAttribute('href', '#top');

  function getAnchorTop(node) {
    return window.scrollY + node.getBoundingClientRect().top;
  }

  function getCurrentItem(nodes, threshold) {
    var current = null;
    for (var i = 0; i < nodes.length; i++) {
      if (getAnchorTop(nodes[i]) <= threshold) {
        current = nodes[i];
      } else {
        break;
      }
    }
    return current || nodes[0] || null;
  }

  function setTrail(link, node) {
    if (!node) return;

    var number = node.getAttribute('data-number') || '';
    var title = node.getAttribute('data-title') || '';
    var text = number ? number + ' ' + title : title;

    link.textContent = text.trim();
    link.setAttribute('href', '#' + node.id);
  }

  function syncMenuState(activeSection, activeSub) {
    var activeHref = activeSub ? '#' + activeSub.id : activeSection ? '#' + activeSection.id : '';
    var parentHref = activeSub && activeSection ? '#' + activeSection.id : '';

    for (var i = 0; i < menuLinks.length; i++) {
      var href = menuLinks[i].getAttribute('href');
      menuLinks[i].classList.toggle('is-current', !!activeHref && href === activeHref);
      menuLinks[i].classList.toggle('is-current-parent', !!parentHref && href === parentHref);
    }
  }

  function setExpanded(nextValue) {
    isExpanded = !!nextValue;
    crumb.classList.toggle('is-expanded', isExpanded);
    toggle.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
    toggle.setAttribute('aria-label', isExpanded ? 'Close page contents' : 'Open page contents');
    menu.hidden = !isExpanded;
  }

  function update() {
    ticking = false;

    var threshold = window.scrollY + 140;
    var showAt = Math.max(220, getAnchorTop(masthead) + masthead.offsetHeight - 100);
    var lexPanelActive = document.body.classList.contains('lex-panel-active');
    var activeSection = getCurrentItem(sections, threshold);
    var activeSub = null;
    var subs;

    if (activeSection) {
      subs = Array.prototype.slice.call(
        activeSection.querySelectorAll('.subsection[id^="subsec-"]')
      );
      if (subs.length) {
        activeSub = getCurrentItem(subs, threshold + 10);
      }
    }

    if (lexPanelActive) {
      setExpanded(false);
      crumb.classList.remove('is-visible');
      crumb.setAttribute('aria-hidden', 'true');
    } else {
      crumb.classList.toggle('is-visible', window.scrollY > showAt);
      crumb.setAttribute('aria-hidden', window.scrollY > showAt ? 'false' : 'true');
    }

    setTrail(sectionLink, activeSection);

    if (activeSub) {
      setTrail(subLink, activeSub);
      subWrap.hidden = false;
    } else {
      subWrap.hidden = true;
      subLink.textContent = '';
      subLink.setAttribute('href', '#top');
    }

    syncMenuState(activeSection, activeSub);
  }

  function requestUpdate() {
    if (ticking) return;
    ticking = true;
    window.requestAnimationFrame(update);
  }

  toggle.addEventListener('click', function (event) {
    event.preventDefault();
    event.stopPropagation();
    setExpanded(!isExpanded);
  });

  menu.addEventListener('click', function (event) {
    var link = event.target.closest('a[href]');
    if (!link) return;
    setExpanded(false);
  });

  document.addEventListener('click', function (event) {
    if (!isExpanded) return;
    if (crumb.contains(event.target)) return;
    setExpanded(false);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && isExpanded) {
      setExpanded(false);
      toggle.focus();
    }
  });

  window.addEventListener('scroll', requestUpdate, { passive: true });
  window.addEventListener('resize', requestUpdate);
  window.addEventListener('load', requestUpdate);
  if ('MutationObserver' in window) {
    new MutationObserver(requestUpdate).observe(document.body, {
      attributes: true,
      attributeFilter: ['class']
    });
  }
  setExpanded(false);
  update();
})();
