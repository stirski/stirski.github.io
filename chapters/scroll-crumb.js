(function () {
  'use strict';

  var crumb = document.getElementById('scroll-crumb');
  var masthead = document.querySelector('.masthead');
  var currentLink = document.getElementById('scroll-crumb-current');
  var chapterKicker = document.getElementById('scroll-crumb-kicker');
  var chapterToggle = document.getElementById('scroll-crumb-home-toggle');
  var chapterMenu = document.getElementById('scroll-crumb-chapter-menu');
  var sectionToggle = document.getElementById('scroll-crumb-toggle');
  var sectionMenu = document.getElementById('scroll-crumb-menu');
  var chapterEyebrow = document.querySelector('.masthead .eyebrow');
  var menuLinks = Array.prototype.slice.call(
    document.querySelectorAll('#scroll-crumb-menu a[href^="#"]')
  );
  var sections = Array.prototype.slice.call(
    document.querySelectorAll('.main section[id^="sec-"]')
  );
  var hoverQuery = window.matchMedia
    ? window.matchMedia('(hover: hover) and (pointer: fine)')
    : null;
  var ticking = false;
  var expandedPanel = null;

  if (
    !crumb ||
    !masthead ||
    !currentLink ||
    !chapterKicker ||
    !chapterToggle ||
    !chapterMenu ||
    !sectionToggle ||
    !sectionMenu ||
    !sections.length
  ) {
    return;
  }

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
    var text = number ? '§ ' + number + ' ' + title : title;

    link.textContent = text.trim();
    link.setAttribute('title', text.trim());
    link.setAttribute('aria-label', text.trim());
    link.setAttribute('href', '#' + node.id);
  }

  function setChapterLabel() {
    var chapterMatch = chapterEyebrow && chapterEyebrow.textContent
      ? chapterEyebrow.textContent.match(/chapter\s+(.+)/i)
      : null;
    var chapterNumber = chapterMatch && chapterMatch[1] ? chapterMatch[1].trim() : '';
    var isWide = window.matchMedia('(min-width: 720px)').matches;

    if (!chapterNumber) {
      chapterKicker.hidden = true;
      chapterKicker.textContent = '';
      chapterKicker.removeAttribute('aria-label');
      chapterKicker.removeAttribute('title');
      return;
    }

    chapterKicker.hidden = false;
    chapterKicker.textContent = (isWide ? 'Chapter ' : 'Ch. ') + chapterNumber;
    chapterKicker.setAttribute('aria-label', 'Chapter ' + chapterNumber);
    chapterKicker.setAttribute('title', 'Chapter ' + chapterNumber);
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

  function setExpanded(panelName) {
    expandedPanel = panelName || null;

    crumb.classList.toggle('is-expanded', !!expandedPanel);
    chapterMenu.hidden = expandedPanel !== 'chapters';
    sectionMenu.hidden = expandedPanel !== 'sections';

    chapterToggle.setAttribute('aria-expanded', expandedPanel === 'chapters' ? 'true' : 'false');
    chapterToggle.setAttribute(
      'aria-label',
      expandedPanel === 'chapters' ? 'Close chapter list' : 'Browse chapters'
    );

    sectionToggle.setAttribute('aria-expanded', expandedPanel === 'sections' ? 'true' : 'false');
    sectionToggle.setAttribute(
      'aria-label',
      expandedPanel === 'sections' ? 'Close page contents' : 'Open page contents'
    );
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
      if (subs.length && getAnchorTop(subs[0]) <= threshold + 10) {
        activeSub = getCurrentItem(subs, threshold + 10);
      }
    }

    if (lexPanelActive) {
      setExpanded(null);
      crumb.classList.remove('is-visible');
      crumb.setAttribute('aria-hidden', 'true');
    } else {
      crumb.classList.toggle('is-visible', window.scrollY > showAt);
      crumb.setAttribute('aria-hidden', window.scrollY > showAt ? 'false' : 'true');
    }

    setTrail(currentLink, activeSub || activeSection);
    setChapterLabel();
    syncMenuState(activeSection, activeSub);
  }

  function requestUpdate() {
    if (ticking) return;
    ticking = true;
    window.requestAnimationFrame(update);
  }

  function supportsHoverOpen() {
    return !!(hoverQuery && hoverQuery.matches);
  }

  chapterToggle.addEventListener('click', function (event) {
    event.preventDefault();
    event.stopPropagation();
    setExpanded(expandedPanel === 'chapters' ? null : 'chapters');
  });

  chapterToggle.addEventListener('mouseenter', function () {
    if (!supportsHoverOpen()) return;
    setExpanded('chapters');
  });

  chapterMenu.addEventListener('mouseenter', function () {
    if (!supportsHoverOpen()) return;
    setExpanded('chapters');
  });

  sectionToggle.addEventListener('click', function (event) {
    event.preventDefault();
    event.stopPropagation();
    setExpanded(expandedPanel === 'sections' ? null : 'sections');
  });

  chapterMenu.addEventListener('click', function (event) {
    var link = event.target.closest('a[href]');
    if (!link) return;
    setExpanded(null);
  });

  sectionMenu.addEventListener('click', function (event) {
    var link = event.target.closest('a[href]');
    if (!link) return;
    setExpanded(null);
  });

  document.addEventListener('click', function (event) {
    if (!expandedPanel) return;
    if (crumb.contains(event.target)) return;
    setExpanded(null);
  });

  crumb.addEventListener('mouseleave', function (event) {
    if (!supportsHoverOpen()) return;
    if (expandedPanel !== 'chapters') return;
    if (event.relatedTarget && crumb.contains(event.relatedTarget)) return;
    setExpanded(null);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key !== 'Escape' || !expandedPanel) return;

    var focusTarget = expandedPanel === 'chapters' ? chapterToggle : sectionToggle;
    setExpanded(null);
    focusTarget.focus();
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
  setExpanded(null);
  update();
})();
