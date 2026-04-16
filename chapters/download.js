(function () {
  var btn = document.getElementById('dl-all');
  if (!btn) return;
  var transliteration = window.StyrianTransliteration || null;
  var expand = (window.StyrianMarkup || {}).expand || function (t) { return t; };

  /* Derive chapter list from the rendered chapter links in the DOM */
  var links = document.querySelectorAll('.chapter-index a');
  var chapters = [];
  for (var i = 0; i < links.length; i++) {
    var no = links[i].querySelector('.chapter-index-no');
    var title = links[i].querySelector('.chapter-index-title');
    var href = links[i].getAttribute('href');
    if (!href) continue;
    chapters.push({
      id: no ? no.textContent.replace(/[^0-9]/g, '') : String(i + 1),
      title: title ? title.textContent : '',
      file: href
    });
  }

  if (chapters.length === 0) return;

  var grammarTitle = document.querySelector('h1').textContent;

  /* ── Lexeme pre-resolver ─────────────────────────────────────────
     Browsers block document() calls inside XSLTProcessor, so <w ref>
     elements would all fall through to the [?ref] missing placeholder.
     We pre-resolve them in JS before handing the XML to XSLT by setting
     @v (display form), @lemma, and @gloss on each <w> element.  The XSL
     template for <w> checks for @v first and skips the document() call
     entirely.
  ──────────────────────────────────────────────────────────────── */

  function candidateFormIds(formId) {
    return ({
      '1s': ['1sg'], '2s': ['2sg'], '3s': ['3sg'],
      '1p': ['1pl'], '2p': ['2pl'], '3p': ['3pl'],
      'pp': ['ppl'],
      'lm': ['lptc.m'], 'lf': ['lptc.f'], 'ln': ['lptc.n'], 'lp': ['lptc.pl'],
      'i2s': ['imp.2sg'], 'i2p': ['imp.2pl'],
      'nm': ['nom.sg'], 'nom.s': ['nom.sg'],
      'o': ['obl.sg'],
      'p': ['pl'],
      'ms': ['m.sg'], 'fs': ['f.sg'], 'ns': ['n.sg'],
      'mo': ['m.sg.obl'], 'fo': ['f.sg.obl'], 'no': ['n.sg.obl'],
      'po': ['pl.obl'], 'o.p': ['pl.obl'], 'o.pl': ['pl.obl'],
      'b': ['base']
    })[formId] || [formId];
  }

  function canonicalFormId(formId) {
    var candidates = candidateFormIds(formId);
    return candidates.length ? candidates[0] : formId;
  }

  function resolveSingleFormJS(entry, formId, lexdoc) {
    var formEls = entry.querySelectorAll('form');
    var i;
    var templateId;
    var tplEls;
    var tpl = null;
    var t;
    var tplForms;
    var pattern = null;
    var p;
    var stemName;
    var stemEls;
    var stemValue = null;
    var mainStem = null;
    var s;

    for (i = 0; i < formEls.length; i++) {
      if (formEls[i].getAttribute('f') === formId) return formEls[i].getAttribute('v');
    }
    templateId = entry.getAttribute('template');
    if (!templateId) return null;
    tplEls = lexdoc.querySelectorAll('templates > *');
    for (t = 0; t < tplEls.length; t++) {
      if (tplEls[t].getAttribute('id') === templateId) { tpl = tplEls[t]; break; }
    }
    if (!tpl) return null;
    tplForms = tpl.querySelectorAll('form');
    for (p = 0; p < tplForms.length; p++) {
      if (tplForms[p].getAttribute('f') === formId) { pattern = tplForms[p]; break; }
    }
    if (!pattern) return null;
    stemName = pattern.getAttribute('stem') || 'main';
    stemEls = entry.querySelectorAll('stem');
    for (s = 0; s < stemEls.length; s++) {
      var sn = stemEls[s].getAttribute('name');
      if (sn === stemName) { stemValue = stemEls[s].getAttribute('v'); break; }
      if (sn === 'main' && !mainStem) mainStem = stemEls[s].getAttribute('v');
    }
    if (!stemValue) stemValue = mainStem;
    if (!stemValue && stemEls.length > 0) stemValue = stemEls[0].getAttribute('v');
    if (!stemValue) return null;
    return (pattern.getAttribute('prefix') || '') + stemValue + (pattern.getAttribute('suffix') || '');
  }

  function resolveFormIdJS(entry, formId, lexdoc) {
    var candidates = candidateFormIds(formId);
    var i;

    for (i = 0; i < candidates.length; i++) {
      if (resolveSingleFormJS(entry, candidates[i], lexdoc)) {
        return candidates[i];
      }
    }

    return candidates.length === 1 ? candidates[0] : null;
  }

  function resolveFormJS(entry, formId, lexdoc) {
    var candidates = candidateFormIds(formId);
    var i;

    for (i = 0; i < candidates.length; i++) {
      var resolved = resolveSingleFormJS(entry, candidates[i], lexdoc);
      if (resolved) return resolved;
    }

    return null;
  }

  function getLemmaJS(entry, lexdoc) {
    var pos = entry.getAttribute('pos');
    if (pos === 'v') { var f = resolveFormJS(entry, 'inf', lexdoc); if (f) return f; }
    if (pos === 'n') { var f2 = resolveFormJS(entry, 'nom.sg', lexdoc); if (f2) return f2; }
    if (pos === 'adj') { var f3 = resolveFormJS(entry, 'm.sg', lexdoc); if (f3) return f3; }
    var firstForm = entry.querySelector('form');
    return firstForm ? firstForm.getAttribute('v') : entry.getAttribute('id');
  }

  var CYR_LOWER = 'абвгдежзийіїклмнопрстуфхцчшӑюя';
  var CYR_UPPER = 'АБВГДЕЖЗИЙІЇКЛМНОПРСТУФХЦЧШӐЮЯ';

  function capFirst(str) {
    if (!str) return str;
    var idx = CYR_LOWER.indexOf(str.charAt(0));
    return idx >= 0 ? CYR_UPPER.charAt(idx) + str.slice(1) : str;
  }

  function preResolveWElements(chXmlDoc, lexdoc) {
    var wEls = chXmlDoc.querySelectorAll('w');
    var lexEntries = lexdoc.querySelectorAll('lex');
    for (var i = 0; i < wEls.length; i++) {
      var w = wEls[i];
      var ref = w.getAttribute('ref') || '';
      var infl = w.getAttribute('infl') || '';
      var cap = w.getAttribute('cap') || '';
      if (!ref) continue;
      var entry = null;
      for (var j = 0; j < lexEntries.length; j++) {
        if (lexEntries[j].getAttribute('id') === ref) { entry = lexEntries[j]; break; }
      }
      if (!entry) continue;
      var lemma = getLemmaJS(entry, lexdoc) || ref;
      var fv = (infl && resolveFormJS(entry, infl, lexdoc)) || lemma;
      var inflResolved = infl ? resolveFormIdJS(entry, infl, lexdoc) : '';
      var gloss = entry.getAttribute('gloss') || '';
      if (cap === '1') fv = capFirst(fv);
      w.setAttribute('v', fv);
      w.setAttribute('lemma', lemma);
      if (inflResolved) w.setAttribute('infl', inflResolved);
      if (gloss) w.setAttribute('gloss', gloss);
    }
  }

  /* ── HTML-to-Markdown converter ──────────────────────────────────
     Walks the XSLT-rendered DOM and produces clean Markdown, stripping
     tooltip popups (.styr-tr) and UI chrome while preserving the visible
     Cyrillic forms, examples, tables, lists, and inline formatting.
  ──────────────────────────────────────────────────────────────── */

  function htmlToMd(root) {
    /* Strip elements that should never appear in the output */
    var dominated = root.querySelectorAll(
      '.styr-tr, .meta, .contents, .navline, .scroll-crumb, ' +
      '.back-to-top, .copy-popup, .lex-overlay, .theme-toggle'
    );
    for (var d = 0; d < dominated.length; d++) dominated[d].remove();

    return convertChildren(root).replace(/\n{3,}/g, '\n\n').trim() + '\n';
  }

  function convertChildren(node) {
    var out = '';
    var kids = node.childNodes;
    for (var i = 0; i < kids.length; i++) out += convertNode(kids[i]);
    return out;
  }

  function convertNode(node) {
    if (node.nodeType === 3) return node.textContent;
    if (node.nodeType !== 1) return '';
    var el = node;
    var tag = el.tagName.toLowerCase();

    /* Headings */
    if (/^h[1-6]$/.test(tag)) {
      var level = parseInt(tag.charAt(1), 10);
      var prefix = '';
      for (var h = 0; h < level; h++) prefix += '#';
      return '\n\n' + prefix + ' ' + textOf(el) + '\n\n';
    }

    /* Paragraphs */
    if (tag === 'p') return '\n\n' + convertChildren(el).trim() + '\n\n';

    /* Section / subsection wrappers */
    if (tag === 'section' || (tag === 'div' && el.classList.contains('subsection')))
      return convertChildren(el);

    /* Unordered lists */
    if (tag === 'ul') return '\n\n' + convertListItems(el) + '\n';

    /* List items */
    if (tag === 'li') return '- ' + convertChildren(el).trim() + '\n';

    /* Tables */
    if (tag === 'table') return '\n\n' + convertTable(el) + '\n\n';
    if (tag === 'div' && el.classList.contains('table-wrap')) return convertChildren(el);

    /* Example sentences */
    if (el.classList.contains('example')) {
      var text = el.querySelector('.example-text');
      var tr = el.querySelector('.example-tr');
      var out = '\n\n> **' + textOf(text || el) + '**';
      if (tr) out += '  \n> *' + textOf(tr) + '*';
      return out + '\n\n';
    }

    /* Styrian tokens — keep only the visible form */
    if (el.classList.contains('styr')) {
      var form = el.querySelector('.styr-form');
      return form ? '**' + form.textContent + '**' : el.textContent;
    }

    /* Inline emphasis */
    if (tag === 'em' || tag === 'i') return '*' + convertChildren(el).trim() + '*';

    /* Inline code */
    if (tag === 'code') return '`' + el.textContent + '`';

    /* Eyebrow labels (Chapter N) — render as a subtle line */
    if (el.classList.contains('eyebrow'))
      return '\n\n---\n\n*' + el.textContent.trim() + '*\n\n';

    /* Masthead header wrapper */
    if (tag === 'header' && el.classList.contains('masthead'))
      return convertChildren(el);

    /* Skip structural wrappers */
    if (tag === 'div' || tag === 'article' || tag === 'main' || tag === 'span' || tag === 'body')
      return convertChildren(el);

    /* thead / tbody / tr — handled by convertTable */
    if (tag === 'thead' || tag === 'tbody' || tag === 'tr' || tag === 'th' || tag === 'td')
      return '';

    /* Fallback: just recurse */
    return convertChildren(el);
  }

  function textOf(el) {
    if (!el) return '';
    /* After .styr-tr removal, .styr-form just has plain text left */
    return el.textContent.trim();
  }

  function convertListItems(ul) {
    var items = ul.querySelectorAll(':scope > li');
    var out = '';
    for (var i = 0; i < items.length; i++)
      out += '- ' + convertChildren(items[i]).trim() + '\n';
    return out;
  }

  function convertTable(table) {
    var rows = [];
    var trs = table.querySelectorAll('tr');
    for (var i = 0; i < trs.length; i++) {
      var cells = trs[i].querySelectorAll('th, td');
      var row = [];
      for (var j = 0; j < cells.length; j++) row.push(textOf(cells[j]));
      rows.push(row);
    }
    if (rows.length === 0) return '';

    /* Normalise column count */
    var cols = 0;
    for (var r = 0; r < rows.length; r++)
      if (rows[r].length > cols) cols = rows[r].length;
    for (var r2 = 0; r2 < rows.length; r2++)
      while (rows[r2].length < cols) rows[r2].push('');

    /* Column widths */
    var widths = [];
    for (var c = 0; c < cols; c++) {
      var w = 3;
      for (var r3 = 0; r3 < rows.length; r3++)
        if (rows[r3][c].length > w) w = rows[r3][c].length;
      widths.push(w);
    }

    function fmtRow(row) {
      var parts = [];
      for (var c = 0; c < cols; c++) {
        var s = row[c];
        while (s.length < widths[c]) s += ' ';
        parts.push(s);
      }
      return '| ' + parts.join(' | ') + ' |';
    }

    var md = fmtRow(rows[0]) + '\n';
    var sep = [];
    for (var c2 = 0; c2 < cols; c2++) {
      var d = '';
      for (var k = 0; k < widths[c2]; k++) d += '-';
      sep.push(d);
    }
    md += '| ' + sep.join(' | ') + ' |\n';
    for (var r4 = 1; r4 < rows.length; r4++) md += fmtRow(rows[r4]) + '\n';
    return md;
  }

  /* ── Build & download ───────────────────────────────────────────── */

  btn.addEventListener('click', function () {
    btn.disabled = true;
    btn.textContent = 'Building\u2026';

    var xslP = fetch('grammar.xsl').then(function (r) { return r.text(); });
    var lexiconUrl = new URL('lexicon.xml', document.baseURI || window.location.href).href;
    var lexiconXmlP = fetch('lexicon.xml').then(function (r) { return r.text(); });
    var mappingP = transliteration
      ? transliteration.loadMappings('cyrillic_mapping.json')
      : Promise.resolve(null);
    var chPs = chapters.map(function (ch) {
      return fetch(ch.file).then(function (r) { return r.text(); });
    });

    Promise.all([xslP, mappingP, lexiconXmlP].concat(chPs)).then(function (results) {
      var xslText = results[0];
      var mappings = results[1];
      var lexiconXmlText = results[2];
      var parser = new DOMParser();
      var lexiconXmlDoc = parser.parseFromString(lexiconXmlText, 'application/xml');
      var xslDoc = parser.parseFromString(xslText, 'application/xml');
      var proc = new XSLTProcessor();
      proc.importStylesheet(xslDoc);
      proc.setParameter(null, 'lexicon-uri', lexiconUrl);

      var mdParts = [];
      mdParts.push('# ' + grammarTitle + '\n');

      for (var i = 3; i < results.length; i++) {
        var chXml = parser.parseFromString(expand(results[i]), 'application/xml');
        preResolveWElements(chXml, lexiconXmlDoc);
        var chHtml = proc.transformToDocument(chXml);
        if (transliteration && mappings) {
          transliteration.applyTransliteration(chHtml, { mappings: mappings });
        }
        var article = chHtml.querySelector('.main.prose, article.main');
        if (!article) article = chHtml.querySelector('.main');
        if (!article) continue;

        var ch = chapters[i - 3];
        mdParts.push('\n---\n');
        mdParts.push('## Chapter ' + ch.id + ': ' + ch.title + '\n');
        mdParts.push(htmlToMd(article));
      }

      var md = mdParts.join('\n').replace(/\n{3,}/g, '\n\n').trim() + '\n';
      var blob = new Blob([md], { type: 'text/markdown;charset=utf-8' });
      var url = URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = url;
      a.download = 'styrian_grammar.md';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      btn.disabled = false;
      btn.innerHTML = '<span class="dl-btn-label">Download full grammar</span>';
    }).catch(function (err) {
      console.error('Download failed:', err);
      btn.disabled = false;
      btn.textContent = 'Download failed \u2014 retry?';
    });
  });
})();
