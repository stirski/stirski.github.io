(function (global) {
  'use strict';

  var lexiconData = null;
  var lexiconPromise = null;
  var panel = null;
  var overlay = null;

  /* ── POS label map ──────────────────────────────────────────── */
  var POS_LABELS = {
    v: 'verb', n: 'noun', adj: 'adjective', pron: 'pronoun',
    art: 'article', prep: 'preposition', part: 'particle', num: 'numeral'
  };

  var FORM_LABELS = {
    'inf': 'infinitive', '1sg': '1st sg', '2sg': '2nd sg', '3sg': '3rd sg',
    '1pl': '1st pl', '2pl': '2nd pl', '3pl': '3rd pl',
    'ppl': 'participle (present)', 'lptc.m': 'l-ptc (masc.)',
    'lptc.f': 'l-ptc (fem.)',
    'lptc.n': 'l-ptc (neuter)', 'lptc.pl': 'l-ptc (plural)',
    'imp.2sg': 'imperative 2sg', 'imp.2pl': 'imperative 2pl',
    'nom.sg': 'nom. sg', 'obl.sg': 'obl. sg', 'pl': 'plural',
    'm.sg': 'masc. sg nom.', 'f.sg': 'fem. sg nom.', 'n.sg': 'neut. sg nom.',
    'm.sg.obl': 'masc. sg obl.', 'f.sg.obl': 'fem. sg obl.', 'n.sg.obl': 'neut. sg obl.',
    'pl.obl': 'plural obl.',
    'base': 'base form'
  };

  /* ── Fetch and parse lexicon.xml ────────────────────────────── */

  function fetchLexicon() {
    if (lexiconPromise) return lexiconPromise;

    lexiconPromise = fetch('lexicon.xml')
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
      })
      .then(function (text) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(text, 'application/xml');
        lexiconData = doc;
        return doc;
      })
      .catch(function (err) {
        console.warn('Could not load lexicon.xml for panel:', err);
        lexiconPromise = null;
        return null;
      });

    return lexiconPromise;
  }

  function getTemplate(entry, doc) {
    var templateId = entry.getAttribute('template');
    if (!templateId) return null;

    var templates = doc.querySelectorAll('templates > *');
    for (var t = 0; t < templates.length; t++) {
      if (templates[t].getAttribute('id') === templateId) {
        return templates[t];
      }
    }

    return null;
  }

  /* ── Resolve a form value from a lex entry ──────────────────── */

  function resolveForm(entry, formId, doc) {
    // Check explicit <form>
    var forms = entry.querySelectorAll('form');
    for (var i = 0; i < forms.length; i++) {
      if (forms[i].getAttribute('f') === formId) {
        return forms[i].getAttribute('v');
      }
    }

    // Fallback to template
    var tpl = getTemplate(entry, doc);
    if (!tpl) return null;

    var tplForms = tpl.querySelectorAll('form');
    var pattern = null;
    for (var p = 0; p < tplForms.length; p++) {
      if (tplForms[p].getAttribute('f') === formId) {
        pattern = tplForms[p];
        break;
      }
    }
    if (!pattern) return null;

    var stemName = pattern.getAttribute('stem') || 'main';
    var stems = entry.querySelectorAll('stem');
    var stemValue = null;
    var mainStem = null;

    for (var s = 0; s < stems.length; s++) {
      var sn = stems[s].getAttribute('name');
      if (sn === stemName) { stemValue = stems[s].getAttribute('v'); break; }
      if (sn === 'main') mainStem = stems[s].getAttribute('v');
    }
    if (!stemValue) stemValue = mainStem;
    if (!stemValue && stems.length > 0) stemValue = stems[0].getAttribute('v');
    if (!stemValue) return null;

    var prefix = pattern.getAttribute('prefix') || '';
    var suffix = pattern.getAttribute('suffix') || '';
    return prefix + stemValue + suffix;
  }

  /* ── Get lemma (citation form) for an entry ─────────────────── */

  function getLemma(entry, doc) {
    var pos = entry.getAttribute('pos');
    var resolved = null;
    if (pos === 'v') resolved = resolveForm(entry, 'inf', doc);
    if (pos === 'n') resolved = resolveForm(entry, 'nom.sg', doc);
    if (pos === 'adj') resolved = resolveForm(entry, 'm.sg', doc);
    if (resolved) return resolved;
    var first = entry.querySelector('form');
    return first ? first.getAttribute('v') : entry.getAttribute('id');
  }

  /* ── Collect all forms with labels ──────────────────────────── */

  function collectForms(entry, doc) {
    var pos = entry.getAttribute('pos');
    var results = [];
    var seen = {};
    var i;

    function pushForm(key) {
      var v = resolveForm(entry, key, doc);
      if (v && !seen[key]) {
        seen[key] = true;
        results.push({ key: key, label: FORM_LABELS[key] || key, value: v });
      }
    }

    // Decide which form keys to show
    var formKeys;
    if (pos === 'v') {
      formKeys = ['inf', '1sg', '2sg', '3sg', '1pl', '2pl', '3pl', 'ppl',
                  'lptc.m', 'lptc.f', 'lptc.n', 'lptc.pl', 'imp.2sg', 'imp.2pl'];
    } else if (pos === 'n') {
      formKeys = ['nom.sg', 'obl.sg', 'pl'];
    } else if (pos === 'adj' || pos === 'art' || pos === 'pron') {
      formKeys = ['m.sg', 'm.sg.obl', 'f.sg', 'f.sg.obl', 'n.sg', 'n.sg.obl', 'pl', 'pl.obl', 'base'];
    } else {
      formKeys = ['m.sg', 'f.sg', 'n.sg', 'pl', 'base'];
    }

    for (i = 0; i < formKeys.length; i++) {
      pushForm(formKeys[i]);
    }

    // Pick up any template-defined forms not in the standard key list.
    var tpl = getTemplate(entry, doc);
    var templateForms = tpl ? tpl.querySelectorAll('form') : [];
    for (i = 0; i < templateForms.length; i++) {
      pushForm(templateForms[i].getAttribute('f'));
    }

    // Also pick up any explicit forms not in the standard keys
    var explicitForms = entry.querySelectorAll('form');
    for (i = 0; i < explicitForms.length; i++) {
      pushForm(explicitForms[i].getAttribute('f'));
    }

    return results;
  }

  /* ── Transliterate helper (uses existing global) ────────────── */

  function trText(cyr) {
    if (global.StyrianTransliteration && global.StyrianTransliteration.transliterateText) {
      return global.StyrianTransliteration.loadMappings().then(function (m) {
        return global.StyrianTransliteration.transliterateText(cyr, m);
      });
    }
    return Promise.resolve(cyr);
  }

  /* ── Build the sidebar panel markup ─────────────────────────── */

  function buildPanel() {
    if (panel) return;

    overlay = document.createElement('div');
    overlay.className = 'lex-overlay';
    overlay.addEventListener('click', closePanel);
    document.body.appendChild(overlay);

    panel = document.createElement('aside');
    panel.className = 'lex-panel';
    panel.innerHTML =
      '<div class="lex-panel-header">' +
        '<button class="lex-panel-close" aria-label="Close" type="button"><i class="bi bi-x-lg" aria-hidden="true"></i></button>' +
      '</div>' +
      '<div class="lex-panel-body"></div>';
    document.body.appendChild(panel);

    panel.querySelector('.lex-panel-close').addEventListener('click', closePanel);

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closePanel();
    });
  }

  function closePanel() {
    if (panel) panel.classList.remove('lex-panel-open');
    if (overlay) overlay.classList.remove('lex-overlay-visible');
    document.body.classList.remove('lex-panel-active');
  }

  /* ── Gather loci (all occurrences of ref on this page) ──────── */

  function getSectionLabel(el) {
    var node = el;
    var subLabel = '';
    var secLabel = '';
    var chLabel = '';

    while (node && node !== document.body) {
      if (!subLabel && node.classList && node.classList.contains('subsection')) {
        var h3 = node.querySelector(':scope > h3');
        if (h3) subLabel = h3.textContent.replace(/^\s+|\s+$/g, '');
      }
      if (!secLabel && node.nodeName === 'SECTION' && node.id && node.id.indexOf('sec-') === 0) {
        var h2 = node.querySelector(':scope > h2');
        if (h2) secLabel = h2.textContent.replace(/^\s+|\s+$/g, '');
      }
      node = node.parentElement;
    }

    var h1 = document.querySelector('.masthead h1');
    if (h1) chLabel = h1.textContent.replace(/^\s+|\s+$/g, '');

    var parts = [];
    if (chLabel) parts.push(chLabel);
    if (secLabel) parts.push(secLabel);
    if (subLabel && subLabel !== secLabel) parts.push(subLabel);
    return parts.join(' \u203a ') || 'Untitled section';
  }

  function getTextContent(node) {
    if (!node) return '';
    if (node.nodeType === 3) return node.nodeValue;
    if (node.nodeType !== 1) return '';
    if (node.classList && node.classList.contains('styr')) {
      var form = node.querySelector('.styr-form');
      return form ? form.textContent : node.textContent;
    }
    var out = '';
    for (var i = 0; i < node.childNodes.length; i++) {
      out += getTextContent(node.childNodes[i]);
    }
    return out;
  }

  function getSurroundingContext(el, maxWords) {
    maxWords = maxWords || 5;

    // Find the nearest block-level parent
    var block = el.parentElement;
    while (block && !/^(P|LI|TD|TH|DIV|SECTION|ARTICLE)$/.test(block.nodeName)) {
      block = block.parentElement;
    }
    if (!block) block = el.parentElement;

    var segments = [];
    function walk(node) {
      if (node === el || (node.nodeType === 1 && node.contains(el))) {
        if (node === el) {
          segments.push({ text: getTextContent(node), isHit: true });
          return;
        }
        for (var c = 0; c < node.childNodes.length; c++) {
          walk(node.childNodes[c]);
        }
        return;
      }
      var t = getTextContent(node);
      if (t) segments.push({ text: t, isHit: false });
    }
    walk(block);

    var hitIdx = -1;
    for (var h = 0; h < segments.length; h++) {
      if (segments[h].isHit) { hitIdx = h; break; }
    }
    if (hitIdx === -1) return { before: '', hit: getTextContent(el), after: '' };

    function joinTokens(segs) {
      return segs.map(function (s) { return s.text; }).join('').replace(/\s+/g, ' ').trim();
    }

    var beforeText = joinTokens(segments.slice(0, hitIdx));
    var afterText = joinTokens(segments.slice(hitIdx + 1));

    var bWords = beforeText.split(/\s+/).filter(Boolean);
    if (bWords.length > maxWords) {
      beforeText = '\u2026 ' + bWords.slice(-maxWords).join(' ');
    }
    var aWords = afterText.split(/\s+/).filter(Boolean);
    if (aWords.length > maxWords) {
      afterText = aWords.slice(0, maxWords).join(' ') + ' \u2026';
    }

    return { before: beforeText, hit: segments[hitIdx].text, after: afterText };
  }

  function gatherLoci(ref) {
    var all = document.querySelectorAll('.styr[data-ref="' + ref + '"]');
    var loci = [];
    for (var i = 0; i < all.length; i++) {
      var el = all[i];
      var ctx = getSurroundingContext(el);
      loci.push({
        element: el,
        section: getSectionLabel(el),
        before: ctx.before,
        hit: ctx.hit,
        after: ctx.after
      });
    }
    return loci;
  }

  var highlightTimer = null;

  function scrollToLocus(el) {
    closePanel();

    var prev = document.querySelectorAll('.lex-highlight');
    for (var i = 0; i < prev.length; i++) prev[i].classList.remove('lex-highlight');
    if (highlightTimer) clearTimeout(highlightTimer);

    el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    el.classList.add('lex-highlight');
    highlightTimer = setTimeout(function () {
      el.classList.remove('lex-highlight');
    }, 2400);
  }

  /* ── Cross-chapter loci scanning ────────────────────────────── */

  var chapterIndex = null;
  var chapterIndexPromise = null;

  function fetchChapterIndex() {
    if (chapterIndexPromise) return chapterIndexPromise;

    chapterIndexPromise = fetch('index.xml')
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
      })
      .then(function (text) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(text, 'application/xml');
        var chs = doc.querySelectorAll('ch');
        var list = [];
        for (var i = 0; i < chs.length; i++) {
          list.push({
            id: chs[i].getAttribute('id'),
            title: chs[i].getAttribute('t'),
            file: chs[i].getAttribute('file')
          });
        }
        chapterIndex = list;
        return list;
      })
      .catch(function (err) {
        console.warn('Could not load index.xml:', err);
        chapterIndex = [];
        return [];
      });

    return chapterIndexPromise;
  }

  function currentChapterFile() {
    // Derive current file from URL
    var path = window.location.pathname;
    var parts = path.split('/');
    return parts[parts.length - 1] || '';
  }

  function getXmlTextContent(node) {
    if (!node) return '';
    if (node.nodeType === 3) return node.nodeValue;
    if (node.nodeType !== 1) return '';
    var out = '';
    for (var i = 0; i < node.childNodes.length; i++) {
      out += getXmlTextContent(node.childNodes[i]);
    }
    return out;
  }

  function getXmlSurrounding(wEl, maxWords) {
    maxWords = maxWords || 5;
    // Find nearest block ancestor: p, item, c
    var block = wEl.parentElement;
    while (block && !/^(p|item|c)$/i.test(block.nodeName)) {
      block = block.parentElement;
    }
    if (!block) block = wEl.parentElement;

    // Build segments
    var segments = [];
    function walk(node) {
      if (node === wEl) {
        // For <w>, use ref attr as placeholder – actual form resolved later
        var v = wEl.getAttribute('v') || wEl.getAttribute('ref') || '';
        segments.push({ text: v, isHit: true });
        return;
      }
      if (node.nodeType === 1 && node.contains(wEl)) {
        for (var c = 0; c < node.childNodes.length; c++) {
          walk(node.childNodes[c]);
        }
        return;
      }
      if (node.nodeType === 1 && (node.nodeName === 'st' || node.nodeName === 'w')) {
        segments.push({ text: node.getAttribute('v') || node.getAttribute('ref') || '', isHit: false });
      } else {
        var t = getXmlTextContent(node);
        if (t) segments.push({ text: t, isHit: false });
      }
    }
    walk(block);

    var hitIdx = -1;
    for (var h = 0; h < segments.length; h++) {
      if (segments[h].isHit) { hitIdx = h; break; }
    }
    if (hitIdx === -1) return { before: '', hit: '', after: '' };

    function joinTokens(segs) {
      return segs.map(function (s) { return s.text; }).join('').replace(/\s+/g, ' ').trim();
    }

    var beforeText = joinTokens(segments.slice(0, hitIdx));
    var afterText = joinTokens(segments.slice(hitIdx + 1));

    var bWords = beforeText.split(/\s+/).filter(Boolean);
    if (bWords.length > maxWords) {
      beforeText = '\u2026 ' + bWords.slice(-maxWords).join(' ');
    }
    var aWords = afterText.split(/\s+/).filter(Boolean);
    if (aWords.length > maxWords) {
      afterText = aWords.slice(0, maxWords).join(' ') + ' \u2026';
    }

    return { before: beforeText, hit: segments[hitIdx].text, after: afterText };
  }

  function getXmlSectionLabel(wEl, chTitle) {
    var node = wEl;
    var secTitle = '';
    var subTitle = '';

    while (node) {
      if (!subTitle && node.nodeName === 'sub') {
        subTitle = node.getAttribute('t') || '';
      }
      if (!secTitle && node.nodeName === 'sec') {
        secTitle = node.getAttribute('t') || '';
      }
      node = node.parentElement;
    }

    var parts = [];
    if (chTitle) parts.push(chTitle);
    if (secTitle) parts.push(secTitle);
    if (subTitle && subTitle !== secTitle) parts.push(subTitle);
    return parts.join(' \u203a ') || chTitle || '';
  }

  function resolveFormDisplay(ref, infl) {
    if (!lexiconData) return ref;
    var entries = lexiconData.querySelectorAll('lex');
    var entry = null;
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].getAttribute('id') === ref) { entry = entries[i]; break; }
    }
    if (!entry) return ref;

    if (infl) {
      var v = resolveForm(entry, infl, lexiconData);
      if (v) return v;
    }
    return getLemma(entry, lexiconData) || ref;
  }

  function gatherCrossChapterLoci(ref) {
    if (!chapterIndex || chapterIndex.length === 0) {
      return Promise.resolve([]);
    }

    var curFile = currentChapterFile();
    var otherChapters = chapterIndex.filter(function (ch) {
      return ch.file !== curFile;
    });

    var fetches = otherChapters.map(function (ch) {
      return fetch(ch.file)
        .then(function (r) {
          if (!r.ok) return null;
          return r.text();
        })
        .then(function (text) {
          if (!text) return [];
          var parser = new DOMParser();
          var doc = parser.parseFromString(text, 'application/xml');
          var wEls = doc.querySelectorAll('w[ref="' + ref + '"]');
          var results = [];
          for (var i = 0; i < wEls.length; i++) {
            var ctx = getXmlSurrounding(wEls[i]);
            var infl = wEls[i].getAttribute('infl') || '';
            var hitDisplay = resolveFormDisplay(ref, infl);
            results.push({
              file: ch.file,
              chTitle: ch.title,
              section: getXmlSectionLabel(wEls[i], ch.title),
              before: ctx.before,
              hit: hitDisplay,
              after: ctx.after
            });
          }
          return results;
        })
        .catch(function () { return []; });
    });

    return Promise.all(fetches).then(function (arrays) {
      var merged = [];
      for (var i = 0; i < arrays.length; i++) {
        for (var j = 0; j < arrays[i].length; j++) {
          merged.push(arrays[i][j]);
        }
      }
      return merged;
    });
  }

  /* ── Build loci HTML helpers ────────────────────────────────── */

  function buildLocalLociHtml(loci) {
    if (loci.length === 0) return '';

    var inner = '<ul class="lex-loci">';
    for (var l = 0; l < loci.length; l++) {
      inner +=
        '<li><a class="lex-locus lex-locus-local" data-locus-idx="' + l + '">' +
          '<span class="lex-locus-section">' + escHtml(loci[l].section) + '</span>' +
          '<span class="lex-locus-context">' +
            (loci[l].before ? '<span class="lex-locus-fade">' + escHtml(loci[l].before) + ' </span>' : '') +
            '<span class="lex-locus-hit">' + escHtml(loci[l].hit) + '</span>' +
            (loci[l].after ? '<span class="lex-locus-fade"> ' + escHtml(loci[l].after) + '</span>' : '') +
          '</span>' +
        '</a></li>';
    }
    inner += '</ul>';

    return '<details class="lex-loci-section" open>' +
      '<summary>This page <span class="lex-loci-count">(' + loci.length + ')</span></summary>' +
      inner +
    '</details>';
  }

  function buildCrossLociHtml(crossLoci) {
    if (crossLoci.length === 0) return '';

    var inner = '<ul class="lex-loci">';
    for (var l = 0; l < crossLoci.length; l++) {
      inner +=
        '<li><a class="lex-locus lex-locus-cross" href="' + escAttr(crossLoci[l].file) + '">' +
          '<span class="lex-locus-section">' + escHtml(crossLoci[l].section) + '</span>' +
          '<span class="lex-locus-context">' +
            (crossLoci[l].before ? '<span class="lex-locus-fade">' + escHtml(crossLoci[l].before) + ' </span>' : '') +
            '<span class="lex-locus-hit">' + escHtml(crossLoci[l].hit) + '</span>' +
            (crossLoci[l].after ? '<span class="lex-locus-fade"> ' + escHtml(crossLoci[l].after) + '</span>' : '') +
          '</span>' +
        '</a></li>';
    }
    inner += '</ul>';

    return '<details class="lex-loci-section">' +
      '<summary>Other chapters <span class="lex-loci-count">(' + crossLoci.length + ')</span></summary>' +
      inner +
    '</details>';
  }

  /* ── Populate and open the panel ────────────────────────────── */

  function openPanel(ref) {
    if (!lexiconData) return;
    buildPanel();

    var entries = lexiconData.querySelectorAll('lex');
    var entry = null;
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].getAttribute('id') === ref) { entry = entries[i]; break; }
    }
    if (!entry) return;

    var pos = entry.getAttribute('pos') || '';
    var asp = entry.getAttribute('asp');
    var vclass = entry.getAttribute('vclass');
    var gen = entry.getAttribute('gen');
    var decl = entry.getAttribute('decl');
    var gloss = entry.getAttribute('gloss') || '';
    var lemma = getLemma(entry, lexiconData) || ref;
    var forms = collectForms(entry, lexiconData);

    // Build meta tags
    var tags = [];
    tags.push(POS_LABELS[pos] || pos);
    if (asp) tags.push(asp);
    if (vclass) tags.push(vclass + '-class');
    if (gen) tags.push(gen === 'm' ? 'masculine' : gen === 'f' ? 'feminine' : gen === 'n' ? 'neuter' : gen);
    if (decl) tags.push(decl + ' decl.');

    var body = panel.querySelector('.lex-panel-body');

    // Build form rows
    var formRowsHtml = '';
    for (var f = 0; f < forms.length; f++) {
      formRowsHtml +=
        '<tr>' +
          '<td class="lex-form-label">' + escHtml(forms[f].label) + '</td>' +
          '<td class="lex-form-cyr">' + escHtml(forms[f].value) + '</td>' +
          '<td class="lex-form-tr" data-cyr-src="' + escAttr(forms[f].value) + '"></td>' +
        '</tr>';
    }

    // Build loci list (local)
    var loci = gatherLoci(ref);
    var lociHtml = buildLocalLociHtml(loci);

    // Placeholder for cross-chapter loci (loaded async)
    var crossPlaceholder = '<div class="lex-cross-loci-slot"></div>';

    body.innerHTML =
      '<div class="lex-lemma" data-cyr-src="' + escAttr(lemma) + '">' +
        '<span class="lex-lemma-cyr">' + escHtml(lemma) + '</span>' +
        '<span class="lex-lemma-tr"></span>' +
      '</div>' +
      '<div class="lex-tags">' + escHtml(tags.join(' \u00b7 ')) + '</div>' +
      '<div class="lex-gloss">' + escHtml(gloss) + '</div>' +
      (forms.length > 0 ?
        '<table class="lex-forms">' +
          '<tbody>' + formRowsHtml + '</tbody>' +
        '</table>' : '') +
      lociHtml +
      crossPlaceholder;

    // Attach local locus click handlers
    var locusLinks = body.querySelectorAll('.lex-locus-local');
    for (var k = 0; k < locusLinks.length; k++) {
      (function (link, idx) {
        link.addEventListener('click', function (e) {
          e.preventDefault();
          if (loci[idx] && loci[idx].element) {
            scrollToLocus(loci[idx].element);
          }
        });
      })(locusLinks[k], parseInt(locusLinks[k].getAttribute('data-locus-idx'), 10));
    }

    // Load cross-chapter loci async
    gatherCrossChapterLoci(ref).then(function (crossLoci) {
      var slot = body.querySelector('.lex-cross-loci-slot');
      if (slot && crossLoci.length > 0) {
        slot.innerHTML = buildCrossLociHtml(crossLoci);
      } else if (slot) {
        slot.remove();
      }
    });

    // Transliterate lemma and forms
    var trCells = body.querySelectorAll('[data-cyr-src]');
    for (var c = 0; c < trCells.length; c++) {
      (function (cell) {
        var cyr = cell.getAttribute('data-cyr-src');
        trText(cyr).then(function (tr) {
          if (cell.classList.contains('lex-lemma')) {
            var trSpan = cell.querySelector('.lex-lemma-tr');
            if (trSpan) trSpan.textContent = tr;
          } else {
            cell.textContent = tr;
          }
        });
      })(trCells[c]);
    }

    panel.classList.add('lex-panel-open');
    overlay.classList.add('lex-overlay-visible');
    document.body.classList.add('lex-panel-active');
  }

  function escHtml(s) {
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  function escAttr(s) {
    return escHtml(s).replace(/"/g, '&quot;');
  }

  /* ── Attach click handlers ──────────────────────────────────── */

  function init() {
    Promise.all([fetchLexicon(), fetchChapterIndex()]).then(function () {
      document.addEventListener('click', function (e) {
        var styr = e.target.closest('.styr[data-ref]');
        if (!styr) return;
        e.preventDefault();
        var ref = styr.getAttribute('data-ref');
        if (ref) openPanel(ref);
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
}(window));
