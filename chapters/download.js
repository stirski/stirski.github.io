(function () {
  var btn = document.getElementById('dl-all');
  if (!btn) return;
  var transliteration = window.StyrianTransliteration || null;
  var expand = (window.StyrianMarkup || {}).expand || function (t) { return t; };

  /* Derive chapter list from the rendered chapter links in the DOM */
  var links = document.querySelectorAll('.chapter-list a');
  var chapters = [];
  for (var i = 0; i < links.length; i++) {
    var no = links[i].querySelector('.chapter-no');
    var title = links[i].querySelector('.chapter-title');
    var file = links[i].querySelector('.chapter-file');
    if (!file) continue;
    chapters.push({
      id: no ? no.textContent.replace(/[^0-9]/g, '') : String(i + 1),
      title: title ? title.textContent : '',
      file: file.textContent.trim()
    });
  }

  if (chapters.length === 0) return;

  var grammarTitle = document.querySelector('h1').textContent;

  /* ── Lexeme pre-resolver ─────────────────────────────────────────
     Browsers block document() calls inside XSLTProcessor, so <w ref>
     elements would all fall through to the [?ref] missing placeholder.
     We pre-resolve them in JS before handing the XML to XSLT by setting
     @v (display form) and @lemma on each <w> element.  The XSL template
     for <w> checks for @v first and skips the document() call entirely.
  ──────────────────────────────────────────────────────────────── */

  function resolveFormJS(entry, formId, lexdoc) {
    var formEls = entry.querySelectorAll('form');
    for (var i = 0; i < formEls.length; i++) {
      if (formEls[i].getAttribute('f') === formId) return formEls[i].getAttribute('v');
    }
    var templateId = entry.getAttribute('template');
    if (!templateId) return null;
    var tplEls = lexdoc.querySelectorAll('templates > *');
    var tpl = null;
    for (var t = 0; t < tplEls.length; t++) {
      if (tplEls[t].getAttribute('id') === templateId) { tpl = tplEls[t]; break; }
    }
    if (!tpl) return null;
    var tplForms = tpl.querySelectorAll('form');
    var pattern = null;
    for (var p = 0; p < tplForms.length; p++) {
      if (tplForms[p].getAttribute('f') === formId) { pattern = tplForms[p]; break; }
    }
    if (!pattern) return null;
    var stemName = pattern.getAttribute('stem') || 'main';
    var stemEls = entry.querySelectorAll('stem');
    var stemValue = null, mainStem = null;
    for (var s = 0; s < stemEls.length; s++) {
      var sn = stemEls[s].getAttribute('name');
      if (sn === stemName) { stemValue = stemEls[s].getAttribute('v'); break; }
      if (sn === 'main' && !mainStem) mainStem = stemEls[s].getAttribute('v');
    }
    if (!stemValue) stemValue = mainStem;
    if (!stemValue && stemEls.length > 0) stemValue = stemEls[0].getAttribute('v');
    if (!stemValue) return null;
    return (pattern.getAttribute('prefix') || '') + stemValue + (pattern.getAttribute('suffix') || '');
  }

  function getLemmaJS(entry, lexdoc) {
    var pos = entry.getAttribute('pos');
    if (pos === 'v') { var f = resolveFormJS(entry, 'inf', lexdoc); if (f) return f; }
    if (pos === 'n') { var f2 = resolveFormJS(entry, 'nom.sg', lexdoc); if (f2) return f2; }
    if (pos === 'adj') { var f3 = resolveFormJS(entry, 'm.sg', lexdoc); if (f3) return f3; }
    var firstForm = entry.querySelector('form');
    return firstForm ? firstForm.getAttribute('v') : entry.getAttribute('id');
  }

  var CYR_LOWER = 'абвгдежзийіклмнопрстуфхцчшъюя';
  var CYR_UPPER = 'АБВГДЕЖЗИЙІКЛМНОПРСТУФХЦЧШЪЮЯ';

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
      if (cap === '1') fv = capFirst(fv);
      w.setAttribute('v', fv);
      w.setAttribute('lemma', lemma);
    }
  }

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

      /* Extract the CSS from a dummy transform */
      var dummyXml = parser.parseFromString(
        '<?xml version="1.0"?><ch id="00" title="dummy"></ch>',
        'application/xml'
      );
      var dummyHtml = proc.transformToDocument(dummyXml);
      var styleEl = dummyHtml.querySelector('style');
      var cssText = styleEl ? styleEl.textContent : '';

      var bodies = [];
      for (var i = 3; i < results.length; i++) {
        var chXml = parser.parseFromString(expand(results[i]), 'application/xml');
        /* Pre-resolve <w> elements before XSLT (browsers block document() in
           XSLTProcessor; the XSL @v short-circuit branch handles these). */
        preResolveWElements(chXml, lexiconXmlDoc);
        var chHtml = proc.transformToDocument(chXml);
        if (transliteration && mappings) {
          transliteration.applyTransliteration(chHtml, { mappings: mappings });
        }
        var article = chHtml.querySelector('.main.prose, article.main');
        if (!article) article = chHtml.querySelector('.main');
        if (!article) continue;

        /* Remove the .meta hint paragraph */
        var meta = article.querySelector('.meta');
        if (meta) meta.remove();

        var ch = chapters[i - 3];
        var header = '<header class="masthead" style="margin-top:2.5rem">' +
          '<p class="eyebrow">Chapter ' + ch.id + '</p>' +
          '<h1>' + ch.title + '</h1></header>';

        bodies.push(header + '<article class="main prose">' +
          article.innerHTML + '</article>');
      }

      var html = '<!DOCTYPE html>\n<html lang="en"><head>' +
        '<meta charset="UTF-8"/>' +
        '<meta name="viewport" content="width=device-width,initial-scale=1"/>' +
        '<title>' + grammarTitle + '</title>' +
        '<style>' + cssText + '</style>' +
        '</head><body><div class="page">' +
        '<header class="masthead"><p class="eyebrow">Full Grammar</p>' +
        '<h1>' + grammarTitle + '</h1></header>' +
        bodies.join('\n') +
        '</div></body></html>';

      var blob = new Blob([html], { type: 'text/html;charset=utf-8' });
      var url = URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = url;
      a.download = 'styrian_grammar.html';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      btn.disabled = false;
      btn.innerHTML = '<svg viewBox="0 0 16 16" aria-hidden="true">' +
        '<path d="M8 1v9.2l2.6-2.6.8.8L8 11.8 4.6 8.4l.8-.8L8 10.2V1zm-5 12v1h10v-1z"/>' +
        '</svg> Download full grammar';
    }).catch(function (err) {
      console.error('Download failed:', err);
      btn.disabled = false;
      btn.textContent = 'Download failed \u2014 retry?';
    });
  });
})();
