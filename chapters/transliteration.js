(function (global) {
  var DEFAULT_MAPPING_PATH = '../cyrillic_mapping.json';
  var cachedPath = null;
  var cachedPromise = null;

  function mergeObjects(base, extra) {
    var out = {};
    var key;
    for (key in base) {
      if (Object.prototype.hasOwnProperty.call(base, key)) {
        out[key] = base[key];
      }
    }
    if (!extra) return out;
    for (key in extra) {
      if (Object.prototype.hasOwnProperty.call(extra, key)) {
        out[key] = String(extra[key]);
      }
    }
    return out;
  }

  function applyCasePattern(source, replacement) {
    if (!source) return replacement;
    if (source.toUpperCase() === source) return replacement.toUpperCase();
    if (source.charAt(0).toUpperCase() === source.charAt(0) &&
        source.slice(1).toLowerCase() === source.slice(1)) {
      return replacement.charAt(0).toUpperCase() + replacement.slice(1);
    }
    return replacement;
  }

  function buildMappings(data) {
    var cyrToLat = mergeObjects({}, data && data.cyr_to_lat);
    var cyrToLatWords = mergeObjects({}, data && data.cyr_to_lat_words);
    return {
      cyrToLat: cyrToLat,
      cyrToLatWords: cyrToLatWords
    };
  }

  function transliterateChars(text, mappings) {
    var out = [];
    var i;
    for (i = 0; i < text.length; i += 1) {
      var ch = text.charAt(i);
      var direct = mappings.cyrToLat[ch];
      if (typeof direct === 'string') {
        out.push(direct);
        continue;
      }

      var lower = ch.toLowerCase();
      if (lower !== ch && typeof mappings.cyrToLat[lower] === 'string') {
        out.push(applyCasePattern(ch, mappings.cyrToLat[lower]));
        continue;
      }

      out.push(ch);
    }
    return out.join('');
  }

  function transliterateText(text, mappings) {
    if (!text) return '';
    return String(text).replace(/[АБВГДЕЖЗИЙІКЛМНОПРСТУФХЦЧШЪЮЯабвгдежзийіклмнопрстуфхцчшъюя]+/g, function (word) {
      var direct = mappings.cyrToLatWords[word];
      if (typeof direct === 'string') return direct;
      return transliterateChars(word, mappings);
    });
  }

  function buildTitle(styr, tr) {
    var formNode = styr.querySelector('.styr-form');
    var display = styr.getAttribute('data-cyr') || (formNode ? formNode.textContent : '');
    var infl = styr.getAttribute('data-infl');
    var lemma = styr.getAttribute('data-lemma') || display;
    var title = display;

    if (tr) {
      title += ' [' + tr + ']';
    }
    if (infl) {
      title += ' · ' + infl + ' of ' + lemma;
    }
    return title;
  }

  function updateToken(styr, mappings) {
    var explicit = styr.getAttribute('data-tr-explicit');
    var formNode = styr.querySelector('.styr-form');
    var bubbleText = styr.querySelector('.styr-tr-text');
    var cyr = styr.getAttribute('data-cyr') || (formNode ? formNode.textContent : '');
    var tr = explicit || transliterateText(cyr, mappings);

    if (tr) {
      styr.setAttribute('data-tr', tr);
    } else {
      styr.removeAttribute('data-tr');
    }

    styr.setAttribute('title', buildTitle(styr, tr));

    if (bubbleText) {
      bubbleText.textContent = tr || '';
    }
  }

  function collectExampleText(node, mappings) {
    var i;
    if (!node) return '';
    if (node.nodeType === 3) return node.nodeValue;
    if (node.nodeType !== 1) return '';

    if (node.classList && node.classList.contains('styr')) {
      var explicit = node.getAttribute('data-tr-explicit');
      if (explicit) return explicit;

      var computed = node.getAttribute('data-tr');
      if (computed) return computed;

      var formNode = node.querySelector('.styr-form');
      var cyr = node.getAttribute('data-cyr') || (formNode ? formNode.textContent : node.textContent);
      return transliterateText(cyr, mappings);
    }

    var text = '';
    for (i = 0; i < node.childNodes.length; i += 1) {
      text += collectExampleText(node.childNodes[i], mappings);
    }
    return text;
  }

  function normalizeWhitespace(text) {
    return String(text || '').replace(/\s+/g, ' ').trim();
  }

  function updateExamples(root, mappings) {
    var examples = root.querySelectorAll('.example');
    var i;
    for (i = 0; i < examples.length; i += 1) {
      var line = examples[i].querySelector('.example-tr');
      var text = examples[i].querySelector('.example-text');
      if (!line || !text) continue;
      if (line.hasAttribute('data-explicit-tr')) continue;
      line.textContent = normalizeWhitespace(collectExampleText(text, mappings));
    }
  }

  function applyTransliteration(root, options) {
    var mappings = options && options.mappings;
    if (!mappings || !root || !root.querySelectorAll) return mappings;

    var tokens = root.querySelectorAll('.styr');
    var i;
    for (i = 0; i < tokens.length; i += 1) {
      updateToken(tokens[i], mappings);
    }
    updateExamples(root, mappings);
    return mappings;
  }

  function loadMappings(path) {
    var resolvedPath = path || DEFAULT_MAPPING_PATH;
    if (cachedPromise && cachedPath === resolvedPath) {
      return cachedPromise;
    }

    cachedPath = resolvedPath;
    cachedPromise = fetch(resolvedPath)
      .then(function (response) {
        if (!response.ok) {
          throw new Error('HTTP ' + response.status);
        }
        return response.json();
      })
      .then(buildMappings)
      .catch(function (error) {
        console.warn('Could not load transliteration mapping:', error);
        return buildMappings({});
      });

    return cachedPromise;
  }

  function init() {
    loadMappings(DEFAULT_MAPPING_PATH).then(function (mappings) {
      applyTransliteration(document, { mappings: mappings });
    });
  }

  global.StyrianTransliteration = {
    applyTransliteration: applyTransliteration,
    loadMappings: loadMappings,
    transliterateText: transliterateText
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
}(window));
