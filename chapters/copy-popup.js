(function () {
  'use strict';

  var popup = null;
  var statusTimer = null;
  var state = {
    cleanText: '',
    translitText: '',
    hasSelection: false
  };

  function getElementTarget(target) {
    if (!target) return null;
    return target.nodeType === 1 ? target : target.parentElement;
  }

  function createPopup() {
    var el = document.createElement('div');
    el.className = 'copy-popup copy-popup-idle';
    el.innerHTML =
      '<button class="copy-popup-btn" data-mode="text" type="button" disabled>' +
        '<i class="bi bi-copy" aria-hidden="true"></i>' +
        '<span>Copy text</span>' +
      '</button>' +
      '<button class="copy-popup-btn" data-mode="translit" type="button" disabled>' +
        '<i class="bi bi-copy" aria-hidden="true"></i>' +
        '<i class="bi bi-translate" aria-hidden="true"></i>' +
        '<span>Copy with transliteration</span>' +
      '</button>' +
      '<span class="copy-popup-hint">Select text to enable</span>' +
      '<span class="copy-popup-confirm" aria-live="polite">' +
        '<i class="bi bi-check2" aria-hidden="true"></i>' +
        '<span>Copied</span>' +
      '</span>' +
      '<span class="copy-popup-error" aria-live="polite">' +
        '<span>Copy failed</span>' +
      '</span>';

    el.addEventListener('click', onPopupClick);
    document.body.appendChild(el);
    return el;
  }

  function ensurePopup() {
    if (!popup) {
      popup = document.querySelector('.copy-popup') || createPopup();
    }
    return popup;
  }

  function clearStatus() {
    var el = ensurePopup();
    el.classList.remove('copy-popup-copied');
    el.classList.remove('copy-popup-failed');
    if (statusTimer) {
      clearTimeout(statusTimer);
      statusTimer = null;
    }
  }

  function setStatus(className, duration) {
    var el = ensurePopup();
    clearStatus();
    el.classList.add(className);
    statusTimer = setTimeout(function () {
      el.classList.remove(className);
      statusTimer = null;
    }, duration);
  }

  function normalizeWhitespace(text) {
    return String(text || '').replace(/\s+/g, ' ').trim();
  }

  function extractClean(node) {
    if (!node) return '';
    if (node.nodeType === 3) return node.nodeValue || '';
    if (node.nodeType !== 1 && node.nodeType !== 11) return '';

    if (node.classList && (
      node.classList.contains('styr-tr') ||
      node.classList.contains('styr-infl-tag')
    )) {
      return '';
    }

    if (node.classList && node.classList.contains('styr')) {
      var formEl = node.querySelector('.styr-form');
      return formEl ? formEl.textContent : (node.getAttribute('data-cyr') || node.textContent || '');
    }

    var out = '';
    var child = node.firstChild;
    while (child) {
      out += extractClean(child);
      child = child.nextSibling;
    }
    return out;
  }

  function buildTranslitString(node, trMap) {
    if (!node) return '';
    if (node.nodeType === 3) return node.nodeValue || '';
    if (node.nodeType !== 1 && node.nodeType !== 11) return '';

    if (node.classList && (
      node.classList.contains('styr-tr') ||
      node.classList.contains('styr-infl-tag')
    )) {
      return '';
    }

    if (node.classList && node.classList.contains('styr')) {
      var formEl = node.querySelector('.styr-form');
      var cyr = formEl ? formEl.textContent : node.getAttribute('data-cyr') || '';
      var tr = node.getAttribute('data-tr') || (trMap && trMap[cyr]) || '';
      return tr ? (cyr + ' [' + tr + ']') : cyr;
    }

    var out = '';
    var child = node.firstChild;
    while (child) {
      out += buildTranslitString(child, trMap);
      child = child.nextSibling;
    }
    return out;
  }

  function buildTranslitMap(range) {
    var map = {};
    var container = range.commonAncestorContainer;
    var liveNodes;
    var i;

    if (container.nodeType === 3) container = container.parentNode;
    liveNodes = container && container.querySelectorAll
      ? container.querySelectorAll('.styr')
      : [];

    for (i = 0; i < liveNodes.length; i += 1) {
      if (!range.intersectsNode(liveNodes[i])) continue;
      var formEl = liveNodes[i].querySelector('.styr-form');
      var cyr = formEl ? formEl.textContent : liveNodes[i].getAttribute('data-cyr') || '';
      var tr = liveNodes[i].getAttribute('data-tr') || '';
      if (cyr && tr) map[cyr] = tr;
    }

    return map;
  }

  function extractTextsFromSelection(sel) {
    if (!sel || sel.rangeCount === 0 || sel.isCollapsed) return null;

    var range = sel.getRangeAt(0);
    var fragment = range.cloneContents();
    var cleanText = normalizeWhitespace(extractClean(fragment));
    var translitText = normalizeWhitespace(buildTranslitString(fragment, buildTranslitMap(range)));

    if (!cleanText) return null;

    return {
      cleanText: cleanText,
      translitText: translitText || cleanText
    };
  }

  function updateButtons() {
    var el = ensurePopup();
    var buttons = el.querySelectorAll('.copy-popup-btn');
    var i;

    el.classList.toggle('copy-popup-idle', !state.hasSelection);
    el.classList.toggle('copy-popup-visible', state.hasSelection);
    document.body.classList.toggle('has-selection', state.hasSelection);

    for (i = 0; i < buttons.length; i += 1) {
      buttons[i].disabled = !state.hasSelection;
    }
  }

  function refreshSelectionState() {
    var data = extractTextsFromSelection(window.getSelection());
    state.hasSelection = !!data;
    state.cleanText = data ? data.cleanText : '';
    state.translitText = data ? data.translitText : '';
    updateButtons();
  }

  function fallbackCopyText(text) {
    var textarea = document.createElement('textarea');
    var selection = window.getSelection();
    var ranges = [];
    var activeElement = document.activeElement;
    var ok = false;
    var i;

    textarea.value = text;
    textarea.setAttribute('readonly', 'readonly');
    textarea.setAttribute('aria-hidden', 'true');
    textarea.style.position = 'fixed';
    textarea.style.top = '-1000px';
    textarea.style.left = '-1000px';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);

    if (selection && selection.rangeCount) {
      for (i = 0; i < selection.rangeCount; i += 1) {
        ranges.push(selection.getRangeAt(i).cloneRange());
      }
    }

    textarea.focus();
    textarea.select();
    textarea.setSelectionRange(0, textarea.value.length);

    try {
      ok = document.execCommand('copy');
    } catch (err) {
      ok = false;
    }

    document.body.removeChild(textarea);

    if (activeElement && activeElement.focus) {
      activeElement.focus();
    }

    if (selection) {
      selection.removeAllRanges();
      for (i = 0; i < ranges.length; i += 1) {
        selection.addRange(ranges[i]);
      }
    }

    return ok;
  }

  function copyText(text) {
    if (!text) return Promise.reject(new Error('No text to copy'));

    if (navigator.clipboard && navigator.clipboard.writeText) {
      try {
        return navigator.clipboard.writeText(text).catch(function () {
          if (fallbackCopyText(text)) return;
          return Promise.reject(new Error('Clipboard write failed'));
        });
      } catch (err) {
        // Some browsers throw synchronously when clipboard access is blocked.
      }
    }

    return fallbackCopyText(text)
      ? Promise.resolve()
      : Promise.reject(new Error('Clipboard write failed'));
  }

  function getCurrentText(mode) {
    var live = extractTextsFromSelection(window.getSelection());
    if (live) {
      state.hasSelection = true;
      state.cleanText = live.cleanText;
      state.translitText = live.translitText;
      updateButtons();
    }

    if (!state.hasSelection) return '';
    return mode === 'translit' ? state.translitText : state.cleanText;
  }

  function onPopupClick(e) {
    var target = getElementTarget(e.target);
    var btn = target && target.closest ? target.closest('.copy-popup-btn') : null;
    var mode;
    var text;

    if (!btn || btn.disabled) return;

    e.preventDefault();
    mode = btn.getAttribute('data-mode');
    text = getCurrentText(mode);

    copyText(text).then(function () {
      setStatus('copy-popup-copied', 1000);
    }, function () {
      setStatus('copy-popup-failed', 1400);
    });
  }

  function selectionHasStyrian(range) {
    var container = range.commonAncestorContainer;
    if (container.nodeType === 3) container = container.parentNode;

    if (container && container.classList && container.classList.contains('styr')) {
      return true;
    }

    if (!container || !container.querySelectorAll) return false;

    var nodes = container.querySelectorAll('.styr');
    for (var i = 0; i < nodes.length; i += 1) {
      if (range.intersectsNode(nodes[i])) return true;
    }
    return false;
  }

  function onCopyShortcut(e) {
    if (!(e.ctrlKey || e.metaKey) || e.key.toLowerCase() !== 'c') return;

    var sel = window.getSelection();
    if (!sel || sel.rangeCount === 0 || sel.isCollapsed) return;

    var range = sel.getRangeAt(0);
    if (!selectionHasStyrian(range)) return;

    var data = extractTextsFromSelection(sel);
    if (!data) return;

    e.preventDefault();
    state.hasSelection = true;
    state.cleanText = data.cleanText;
    state.translitText = data.translitText;
    updateButtons();

    copyText(data.cleanText).then(function () {
      setStatus('copy-popup-copied', 1000);
    }, function () {
      setStatus('copy-popup-failed', 1400);
    });
  }

  function init() {
    ensurePopup();
    updateButtons();

    document.addEventListener('selectionchange', refreshSelectionState);
    document.addEventListener('mouseup', function () {
      setTimeout(refreshSelectionState, 0);
    });
    document.addEventListener('keyup', function () {
      setTimeout(refreshSelectionState, 0);
    });
    document.addEventListener('keydown', onCopyShortcut);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
