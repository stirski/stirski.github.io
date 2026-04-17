/**
 * markup.js — Compact inline notation expander for Styrian grammar files.
 *
 * Exposes window.StyrianMarkup.expand(text) which converts the compact
 * bracket notation back to valid XML self-closing tags before the text is
 * handed to DOMParser.
 *
 * Compact format (mirrors markup.py):
 *
 *   [w az]                  →  <w ref="az"/>
 *   [w vydit :i 1s]         →  <w ref="vydit" infl="1s"/>
 *   [w dom :i o]            →  <w ref="dom" infl="o"/>
 *   [w ydat :c]             →  <w ref="ydat" cap="1"/>
 *   [w sej :i ms :c]        →  <w ref="sej" infl="ms" cap="1"/>
 *
 *   [st нов]                →  <st v="нов" tr=""/>
 *   [st Страски :t Strasky] →  <st v="Страски" tr="Strasky"/>
 *   [st не знам :t ne znam] →  <st v="не знам" tr="ne znam"/>
 */

(function (global) {
  'use strict';

  /**
   * Expand compact bracket tokens to XML self-closing tags.
   * All other content (structural XML, text, attributes) is left unchanged.
   *
   * @param  {string} text  Raw compact-notation XML string.
   * @return {string}       Valid XML string with <w> and <st> tags restored.
   */
  function expand(text) {
    // ── [w ...] ──────────────────────────────────────────────────────────
    // Groups: (1) ref  (2) infl (optional)  (3) ' :c' cap flag (optional)
    text = text.replace(
      /\[w ([^\] :]+)(?: :i ([^\] :]+))?( :c)?\]/g,
      function (_, ref, infl, cap) {
        var tag = '<w ref="' + ref + '"';
        if (infl) { tag += ' infl="' + infl + '"'; }
        if (cap)  { tag += ' cap="1"'; }
        return tag + '/>';
      }
    );

    // ── [st ...] ─────────────────────────────────────────────────────────
    // The Cyrillic v value may contain spaces; ' :t ' is the safe delimiter
    // because Cyrillic text never contains the ASCII sequence ':t'.
    text = text.replace(
      /\[st ([^\]]+?)\]/g,
      function (_, content) {
        var sep = content.indexOf(' :t ');
        var v   = sep >= 0 ? content.slice(0, sep).trim() : content.trim();
        var tr  = sep >= 0 ? content.slice(sep + 4).trim() : '';
        return '<st v="' + v + '" tr="' + tr + '"/>';
      }
    );

    return text;
  }

  // ── Self-test (runs once on load in development; silent in production) ──
  function selfTest() {
    var cases = [
      ['[w az]',                    '<w ref="az"/>'],
      ['[w vydit :i 1s]',           '<w ref="vydit" infl="1s"/>'],
      ['[w dom :i o]',              '<w ref="dom" infl="o"/>'],
      ['[w ydat :c]',               '<w ref="ydat" cap="1"/>'],
      ['[w sej :i ms :c]',          '<w ref="sej" infl="ms" cap="1"/>'],
      ['[w byt.neg :i 3s]',         '<w ref="byt.neg" infl="3s"/>'],
      ['[st нов]',                  '<st v="нов" tr=""/>'],
      ['[st Страски :t Strasky]',   '<st v="Страски" tr="Strasky"/>'],
      ['[st не знам :t ne znam]',   '<st v="не знам" tr="ne znam"/>'],
    ];
    var failed = 0;
    cases.forEach(function (pair) {
      var got = expand(pair[0]);
      if (got !== pair[1]) {
        console.error('[markup.js] FAIL:', pair[0]);
        console.error('  expected:', pair[1]);
        console.error('  got:     ', got);
        failed++;
      }
    });
    if (!failed) {
      console.debug('[markup.js] all self-tests passed.');
    }
  }

  if (typeof console !== 'undefined' && console.debug) {
    selfTest();
  }

  global.StyrianMarkup = { expand: expand };

}(typeof window !== 'undefined' ? window : this));
