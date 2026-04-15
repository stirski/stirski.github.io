(function () {
  'use strict';

  var STORAGE_KEY = 'styrian-theme';
  var root = document.documentElement;
  var media = window.matchMedia ? window.matchMedia('(prefers-color-scheme: dark)') : null;
  var currentMode = 'auto';

  function normalizeMode(mode) {
    return mode === 'light' || mode === 'dark' || mode === 'auto' ? mode : 'auto';
  }

  function readStoredMode() {
    try {
      return normalizeMode(localStorage.getItem(STORAGE_KEY));
    } catch (error) {
      return 'auto';
    }
  }

  function resolvedTheme(mode) {
    if (mode === 'light' || mode === 'dark') return mode;
    return media && media.matches ? 'dark' : 'light';
  }

  function describeMode(mode) {
    if (mode === 'dark') return 'Dark';
    if (mode === 'light') return 'Light';
    return 'Auto';
  }

  function nextMode(mode) {
    if (mode === 'auto') return 'dark';
    if (mode === 'dark') return 'light';
    return 'auto';
  }

  function iconClass(mode) {
    if (mode === 'dark') return 'bi-moon-stars-fill';
    if (mode === 'light') return 'bi-sun-fill';
    return 'bi-circle-half';
  }

  function syncButtons() {
    var buttons = document.querySelectorAll('[data-theme-toggle]');
    var labelText = describeMode(currentMode);
    var nextLabel = describeMode(nextMode(currentMode));
    var title = currentMode === 'auto'
      ? 'Theme: Auto (following browser setting). Click to switch to ' + nextLabel + '.'
      : 'Theme: ' + labelText + '. Click to switch to ' + nextLabel + '.';

    for (var i = 0; i < buttons.length; i++) {
      var button = buttons[i];
      var label = button.querySelector('[data-theme-label]');
      var icon = button.querySelector('[data-theme-icon]');
      var prefix = button.getAttribute('data-theme-label-prefix') || 'Theme';

      button.setAttribute('data-theme-mode', currentMode);
      button.setAttribute('title', title);
      button.setAttribute('aria-label', title);

      if (label) {
        label.textContent = prefix + ': ' + labelText;
      }

      if (icon) {
        icon.className = 'bi ' + iconClass(currentMode);
      }
    }
  }

  function applyTheme(mode, persist) {
    currentMode = normalizeMode(mode);
    root.setAttribute('data-theme-mode', currentMode);
    root.setAttribute('data-theme', resolvedTheme(currentMode));

    if (persist) {
      try {
        if (currentMode === 'auto') {
          localStorage.removeItem(STORAGE_KEY);
        } else {
          localStorage.setItem(STORAGE_KEY, currentMode);
        }
      } catch (error) {
        // Ignore localStorage failures and continue with the in-memory theme.
      }
    }

    syncButtons();
  }

  document.addEventListener('click', function (event) {
    var button = event.target.closest('[data-theme-toggle]');
    if (!button) return;

    event.preventDefault();
    applyTheme(nextMode(currentMode), true);
  });

  if (media) {
    if (typeof media.addEventListener === 'function') {
      media.addEventListener('change', function () {
        if (currentMode === 'auto') applyTheme('auto', false);
      });
    } else if (typeof media.addListener === 'function') {
      media.addListener(function () {
        if (currentMode === 'auto') applyTheme('auto', false);
      });
    }
  }

  document.addEventListener('DOMContentLoaded', syncButtons);
  applyTheme(root.getAttribute('data-theme-mode') || readStoredMode(), false);
})();
