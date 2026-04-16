<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="grammar ch sec sub list tb r"/>
  <xsl:param name="lexicon-uri" select="'lexicon.xml'"/>

  <xsl:template match="/">
    <xsl:apply-templates select="grammar | ch"/>
  </xsl:template>

  <xsl:template name="document-head">
    <xsl:param name="title"/>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <meta name="color-scheme" content="light dark"/>
      <title><xsl:value-of select="$title"/> &#x2014; A Grammar of Styrian</title>
      <script><![CDATA[
        (function () {
          var storageKey = 'styrian-theme';
          var root = document.documentElement;
          var mode = 'auto';

          try {
            var stored = localStorage.getItem(storageKey);
            if (stored === 'light' || stored === 'dark') {
              mode = stored;
            }
          } catch (error) {
            mode = 'auto';
          }

          var prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
          root.setAttribute('data-theme-mode', mode);
          root.setAttribute('data-theme', mode === 'auto' ? (prefersDark ? 'dark' : 'light') : mode);
        })();
      ]]></script>
      <link rel="preconnect" href="https://fonts.googleapis.com"/>
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;display=swap"/>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"/>
      <style type="text/css"><![CDATA[
        :root {
          color-scheme: light;
          --paper: #f5f7fa;
          --paper-rgb: 245, 247, 250;
          --ink: #16181d;
          --ink-rgb: 22, 24, 29;
          --muted: #6f7782;
          --rule: #d9e0e8;
          --accent: #111111;
          --accent-soft: #edf1f5;
          --code-bg: #e9eef4;
          --code-border: rgba(22, 24, 29, 0.08);
          --code-ink: #1a1d23;
          --signal: #2f6fd6;
          --signal-rgb: 47, 111, 214;
          --mark-rgb: 183, 206, 244;
          --page-grad-start: #f9fbfd;
          --page-grad-mid: #f2f5f9;
          --page-grad-end: #f7f9fc;
          --surface-card: rgba(255, 255, 255, 0.82);
          --surface-glass: rgba(250, 252, 255, 0.7);
          --surface-menu: rgba(248, 250, 253, 0.76);
          --surface-float: rgba(251, 253, 255, 0.76);
          --surface-float-hover: rgba(255, 255, 255, 0.82);
          --surface-overlay: rgba(248, 250, 253, 0.66);
          --surface-overlay-strong: rgba(248, 250, 253, 0.76);
          --surface-overlay-inverse: rgba(17, 17, 17, 0.66);
          --surface-overlay-inverse-hover: rgba(17, 17, 17, 0.74);
          --surface-tooltip: rgba(17, 17, 17, 0.9);
          --tooltip-text: rgba(255, 255, 255, 0.92);
          --tooltip-divider: rgba(255, 255, 255, 0.14);
          --surface-popup: rgba(17, 17, 17, 0.78);
          --popup-text: rgba(255, 255, 255, 0.92);
          --popup-text-soft: rgba(255, 255, 255, 0.82);
          --popup-text-muted: rgba(255, 255, 255, 0.66);
          --popup-divider: rgba(255, 255, 255, 0.14);
          --surface-border: rgba(17, 17, 17, 0.08);
          --overlay-border: rgba(255, 255, 255, 0.24);
          --overlay-highlight: rgba(255, 255, 255, 0.12);
          --overlay-highlight-soft: rgba(255, 255, 255, 0.03);
          --divider-soft: rgba(17, 17, 17, 0.1);
          --icon-muted: rgba(17, 17, 17, 0.56);
          --icon-soft: rgba(17, 17, 17, 0.54);
          --icon-strong: rgba(17, 17, 17, 0.72);
          --icon-stronger: rgba(17, 17, 17, 0.78);
          --hover-faint: rgba(17, 17, 17, 0.04);
          --hover-soft: rgba(17, 17, 17, 0.05);
          --hover-medium: rgba(17, 17, 17, 0.06);
          --hover-strong: rgba(17, 17, 17, 0.16);
          --active-soft: rgba(17, 17, 17, 0.08);
          --scrollbar-thumb: rgba(17, 17, 17, 0.16);
          --scrollbar-thumb-strong: rgba(17, 17, 17, 0.18);
          --shadow-card: 0 16px 40px rgba(17, 17, 17, 0.04);
          --shadow-glass: 0 20px 44px rgba(17, 17, 17, 0.08);
          --shadow-float: 0 4px 16px rgba(0, 0, 0, 0.06);
          --shadow-float-hover: 0 6px 20px rgba(0, 0, 0, 0.08);
          --shadow-side: -4px 0 24px rgba(0, 0, 0, 0.08);
          --shadow-popup: 0 4px 16px rgba(0, 0, 0, 0.18), 0 1px 3px rgba(0, 0, 0, 0.1);
          --overlay: rgba(232, 238, 245, 0.22);
          --inverse-surface: #111111;
          --inverse-surface-hover: #333333;
          --inverse-text: rgba(255, 255, 255, 0.88);
          --inverse-text-soft: rgba(255, 255, 255, 0.82);
          --inverse-text-muted: rgba(255, 255, 255, 0.62);
          --inverse-divider: rgba(255, 255, 255, 0.12);
          --tooltip-muted: rgba(255, 255, 255, 0.68);
          --danger-surface: #6f2418;
          --danger-text: rgba(255, 234, 230, 0.95);
          --font-body: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", Inter, "Segoe UI", sans-serif;
          --font-display: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", Inter, "Segoe UI", sans-serif;
          --font-ui: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", Inter, "Segoe UI", sans-serif;
          --font-mono: "SFMono-Regular", "Cascadia Mono", Consolas, monospace;
          --page-max: 64rem;
          --crumb-max: 54rem;
          --content-max: calc(var(--crumb-max) * 0.95);
          --measure: min(44rem, var(--content-max));
          --margin-col: 13.5rem;
          --layout-gap: 2rem;
          --section-space: clamp(3rem, 4.8vw, 4.1rem);
          --subsection-space: clamp(1.9rem, 3vw, 2.4rem);
          --section-heading-gap: clamp(1.05rem, 1.7vw, 1.28rem);
          --subsection-heading-gap: 0.72rem;
        }

        html[data-theme='dark'] {
          color-scheme: dark;
          --paper: #111317;
          --paper-rgb: 17, 19, 23;
          --ink: #e7edf4;
          --ink-rgb: 231, 237, 244;
          --muted: #98a4b6;
          --rule: #2c3440;
          --accent: #f3f7fd;
          --accent-soft: #1a1f26;
          --code-bg: #1c232d;
          --code-border: rgba(120, 151, 204, 0.2);
          --code-ink: #f3f7fd;
          --signal: #7897cc;
          --signal-rgb: 120, 151, 204;
          --mark-rgb: 83, 112, 160;
          --page-grad-start: #0e1116;
          --page-grad-mid: #141920;
          --page-grad-end: #10141a;
          --surface-card: rgba(20, 24, 29, 0.84);
          --surface-glass: rgba(18, 22, 27, 0.76);
          --surface-menu: rgba(18, 22, 27, 0.8);
          --surface-float: rgba(23, 28, 34, 0.72);
          --surface-float-hover: rgba(28, 34, 41, 0.78);
          --surface-overlay: rgba(18, 22, 27, 0.7);
          --surface-overlay-strong: rgba(18, 22, 27, 0.78);
          --surface-overlay-inverse: rgba(237, 243, 251, 0.18);
          --surface-overlay-inverse-hover: rgba(255, 255, 255, 0.24);
          --surface-tooltip: rgba(15, 19, 24, 0.9);
          --tooltip-text: rgba(246, 249, 253, 0.94);
          --tooltip-divider: rgba(255, 255, 255, 0.16);
          --surface-popup: rgba(15, 19, 24, 0.9);
          --popup-text: rgba(246, 249, 253, 0.94);
          --popup-text-soft: rgba(246, 249, 253, 0.84);
          --popup-text-muted: rgba(246, 249, 253, 0.7);
          --popup-divider: rgba(255, 255, 255, 0.16);
          --surface-border: rgba(231, 237, 245, 0.08);
          --overlay-border: rgba(255, 255, 255, 0.1);
          --overlay-highlight: rgba(255, 255, 255, 0.06);
          --overlay-highlight-soft: rgba(255, 255, 255, 0.015);
          --divider-soft: rgba(231, 237, 245, 0.12);
          --icon-muted: rgba(231, 237, 245, 0.64);
          --icon-soft: rgba(231, 237, 245, 0.58);
          --icon-strong: rgba(231, 237, 245, 0.78);
          --icon-stronger: rgba(231, 237, 245, 0.88);
          --hover-faint: rgba(140, 165, 205, 0.08);
          --hover-soft: rgba(140, 165, 205, 0.1);
          --hover-medium: rgba(140, 165, 205, 0.13);
          --hover-strong: rgba(140, 165, 205, 0.22);
          --active-soft: rgba(120, 151, 204, 0.16);
          --scrollbar-thumb: rgba(140, 165, 205, 0.2);
          --scrollbar-thumb-strong: rgba(140, 165, 205, 0.26);
          --shadow-card: 0 18px 42px rgba(0, 0, 0, 0.32);
          --shadow-glass: 0 22px 52px rgba(0, 0, 0, 0.36);
          --shadow-float: 0 10px 24px rgba(0, 0, 0, 0.24);
          --shadow-float-hover: 0 14px 30px rgba(0, 0, 0, 0.3);
          --shadow-side: -8px 0 28px rgba(0, 0, 0, 0.34);
          --shadow-popup: 0 10px 28px rgba(0, 0, 0, 0.36), 0 2px 8px rgba(0, 0, 0, 0.24);
          --overlay: rgba(8, 10, 14, 0.46);
          --inverse-surface: #edf3fb;
          --inverse-surface-hover: #ffffff;
          --inverse-text: rgba(17, 20, 25, 0.92);
          --inverse-text-soft: rgba(17, 20, 25, 0.84);
          --inverse-text-muted: rgba(17, 20, 25, 0.64);
          --inverse-divider: rgba(17, 20, 25, 0.14);
          --tooltip-muted: rgba(246, 249, 253, 0.72);
          --danger-surface: #8e3525;
          --danger-text: #fff1ed;
        }


        html {
          font-size: 14.5px;
          scroll-behavior: smooth;
        }

        body {
          margin: 0;
          background:
            linear-gradient(180deg, var(--page-grad-start) 0%, var(--page-grad-mid) 22rem, var(--page-grad-end) 100%);
          color: var(--ink);
          font-family: var(--font-body);
          font-optical-sizing: auto;
          text-rendering: optimizeLegibility;
          -webkit-font-smoothing: antialiased;
          font-kerning: normal;
          font-variant-numeric: lining-nums proportional-nums;
          letter-spacing: -0.012em;
        }

        a {
          color: inherit;
          text-decoration-color: rgba(var(--signal-rgb), 0.2);
          text-underline-offset: 0.16em;
        }

        a:hover {
          text-decoration-color: rgba(var(--signal-rgb), 0.46);
        }

        .page {
          width: min(calc(100vw - 2.5rem), var(--page-max));
          margin: 0 auto;
          padding: clamp(1.6rem, 4vw, 2.5rem) 0 4rem;
          position: relative;
          z-index: 1;
        }

        .masthead {
          padding: 0 0 1.15rem;
          margin-bottom: 1.75rem;
        }

        .chapter-masthead-body {
          max-width: min(100%, var(--crumb-max));
          margin: 0 auto;
        }

        .eyebrow {
          margin: 0 0 0.45rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.7rem;
          font-weight: 500;
          letter-spacing: 0.02em;
        }

        h1,
        h2,
        h3 {
          margin: 0;
          font-family: var(--font-display);
          font-weight: 600;
          line-height: 0.98;
          color: var(--accent);
          text-wrap: balance;
        }

        h1 {
          margin-bottom: 2.25rem;
          letter-spacing: -0.032em;
        }

        .deck {
          max-width: 30rem;
          margin: 0.85rem 0 0;
          color: var(--muted);
          font-size: 1.02rem;
          line-height: 1.58;
          letter-spacing: -0.01em;
        }

        .navline {
          display: flex;
          flex-wrap: wrap;
          align-items: center;
          gap: 0.9rem 1.35rem;
          margin-top: 1rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.75rem;
          font-weight: 500;
          letter-spacing: 0.01em;
        }


        .layout {
          display: block;
        }

        .main {
          min-width: 0;
        }

        .aside {
          min-width: 0;
        }

        .chapter-layout .main {
          max-width: min(100%, var(--crumb-max));
          margin: 0 auto;
        }

        .prose {
          hanging-punctuation: first last;
          hyphens: auto;
          font-size: clamp(1.01rem, 0.98rem + 0.16vw, 1.06rem);
          line-height: 1.68;
          letter-spacing: -0.011em;
        }

        .chapter-layout .prose {
          width: min(100%, var(--content-max));
        }

        .prose p,
        .prose ul,
        .prose ol,
        .prose section,
        .prose .subsection {
          max-width: var(--measure);
        }

        .prose p {
          margin: 0 0 1.05rem;
        }

        .prose p + p {
          margin-top: -0.1rem;
        }

        .prose ul,
        .prose ol {
          margin: 0.65rem 0 1.1rem 1.3rem;
          padding: 0;
        }

        .prose li {
          margin: 0.4rem 0;
        }

        .prose > section {
          margin-top: calc(var(--section-space) + 0.6rem);
        }

        .prose .subsection {
          margin-top: calc(var(--subsection-space) + 0.15rem);
        }

        .prose > section:first-of-type {
          margin-top: clamp(2.7rem, 4.5vw, 3.5rem);
        }

        .prose > section > :last-child,
        .prose .subsection > :last-child {
          margin-bottom: 0;
        }

        .prose section[id],
        .prose .subsection[id] {
          scroll-margin-top: 5.5rem;
        }

        .prose h2 {
          max-width: var(--measure);
          margin: 0 0 var(--section-heading-gap);
          padding-top: 0;
          font-weight: 600;
          font-size: clamp(1.38rem, 1.3rem + 0.22vw, 1.54rem);
          line-height: 1.1;
          letter-spacing: -0.024em;
        }

        .prose h3 {
          max-width: var(--measure);
          margin: 0 0 var(--subsection-heading-gap);
          font-weight: 600;
          font-size: clamp(1.1rem, 1.07rem + 0.1vw, 1.16rem);
          line-height: 1.14;
          letter-spacing: -0.016em;
          color: var(--muted);
        }

        .section-number {
          display: inline-block;
          margin-right: 0.45rem;
          color: rgba(var(--ink-rgb), 0.38);
          font-family: var(--font-display);
          font-size: 0.88em;
          font-weight: 500;
          line-height: 1;
          letter-spacing: 0;
          font-variant-numeric: tabular-nums;
        }

        h3 > .section-number {
          color: rgba(var(--ink-rgb), 0.34);
        }

        .contents {
          margin: 0;
          padding: 1rem 1rem 1.05rem;
          list-style: none;
          border: 1px solid var(--rule);
          border-radius: 0.9rem;
          background: var(--surface-card);
          box-shadow: var(--shadow-card);
          font-size: 0.92rem;
          line-height: 1.5;
          backdrop-filter: blur(10px);
          -webkit-backdrop-filter: blur(10px);
        }

        .contents li + li {
          margin-top: 0.45rem;
        }

        .contents a {
          text-decoration: none;
        }

        .contents a:hover {
          color: var(--accent);
        }

        .contents .toc-sublist {
          margin: 0.45rem 0 0.2rem 0.8rem;
          padding: 0 0 0 0.8rem;
          list-style: none;
          border-left: 1px solid var(--rule);
        }

        .contents .toc-number {
          display: inline-block;
          min-width: 2.5em;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.78em;
          font-weight: 500;
          letter-spacing: 0.04em;
        }

        .scroll-crumb {
          position: fixed;
          top: 0.85rem;
          left: 50%;
          z-index: 170;
          width: min(calc(100vw - 1.5rem), var(--crumb-max));
          isolation: isolate;
          opacity: 0;
          visibility: hidden;
          pointer-events: none;
          transform: translateX(-50%) translateY(-0.7rem);
          transition:
            opacity 180ms ease,
            transform 180ms ease,
            visibility 180ms ease;
        }

        .scroll-crumb.is-visible {
          opacity: 1;
          visibility: visible;
          pointer-events: auto;
          transform: translateX(-50%) translateY(0);
        }

        body.lex-panel-active .scroll-crumb {
          opacity: 0;
          visibility: hidden;
          pointer-events: none;
          transform: translateX(-50%) translateY(-0.7rem);
        }

        .scroll-crumb-inner {
          position: relative;
          display: flex;
          align-items: center;
          gap: 0.45rem;
          min-height: 3rem;
          padding: 0.45rem 1.05rem 0.45rem 1rem;
          border-radius: 1.1rem;
          overflow: hidden;
        }

        .scroll-crumb-inner::before {
          content: "";
          position: absolute;
          inset: 0;
          border: 1px solid var(--overlay-border);
          border-radius: inherit;
          background: var(--surface-overlay);
          box-shadow: var(--shadow-glass), inset 0 1px 0 var(--overlay-highlight);
          backdrop-filter: blur(22px) saturate(145%);
          -webkit-backdrop-filter: blur(22px) saturate(145%);
          pointer-events: none;
          z-index: 0;
        }

        .scroll-crumb-inner > * {
          position: relative;
          z-index: 1;
        }

        .scroll-crumb-item {
          display: inline-flex;
          align-items: center;
          min-width: 0;
          padding: 0.35rem 0.7rem;
          border-radius: 0.8rem;
          text-decoration: none;
          white-space: nowrap;
          transition: color 120ms ease;
        }

        .scroll-crumb-home {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          flex: 0 0 auto;
          gap: 0.38rem;
          min-width: 0;
          padding: 0 0.1rem 0 0.18rem;
          border: 0;
          background: transparent;
          color: inherit;
          font: inherit;
          cursor: pointer;
        }

        .scroll-crumb-home .bi {
          font-size: 0.95rem;
          line-height: 1;
          padding-left: 0.14rem;
          color: var(--icon-muted);
          transition: color 120ms ease;
        }

        .scroll-crumb-home:hover .bi {
          color: rgba(var(--signal-rgb), 0.82);
        }

        .scroll-crumb-home-label {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.78rem;
          font-weight: 600;
          letter-spacing: 0.03em;
          line-height: 1.45;
          white-space: nowrap;
          opacity: 0;
          max-width: 0;
          overflow: hidden;
          transition: opacity 120ms ease, max-width 120ms ease;
        }

        .scroll-crumb-home:hover .scroll-crumb-home-label,
        .scroll-crumb-home:focus-visible .scroll-crumb-home-label {
          color: rgba(var(--signal-rgb), 0.82);
          opacity: 1;
          max-width: 8rem;
        }

        .scroll-crumb-home::after {
          content: "";
          width: 1px;
          height: 1rem;
          margin-left: 0.55rem;
          background: var(--divider-soft);
        }

        .scroll-crumb-kicker {
          display: inline-flex;
          align-items: center;
          flex: 0 0 auto;
          min-width: 0;
          padding-left: 0.05rem;
          color: var(--icon-muted);
          font-family: var(--font-ui);
          font-size: 0.72rem;
          font-weight: 500;
          letter-spacing: 0.02em;
          white-space: nowrap;
        }

        .scroll-crumb-kicker::after {
          content: "";
          width: 1px;
          height: 1rem;
          margin-left: 0.55rem;
          background: var(--divider-soft);
        }

        .scroll-crumb-kicker[hidden] {
          display: none;
        }

        .scroll-crumb-current {
          flex: 1 1 auto;
          min-width: 0;
          color: var(--accent);
          font-size: 0.98rem;
          font-weight: 600;
          overflow: hidden;
          text-overflow: ellipsis;
          padding-left: 0.05rem;
        }

        .scroll-crumb-chapter-link {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          flex: 0 0 auto;
          width: 2rem;
          height: 2rem;
          padding: 0;
          border-radius: 999px;
          color: var(--icon-soft);
          transition: background 120ms ease, color 120ms ease;
        }

        .scroll-crumb-chapter-link:hover,
        .scroll-crumb-chapter-link:focus-visible {
          background: var(--hover-medium);
          color: var(--icon-stronger);
          outline: none;
        }

        .scroll-crumb-chapter-link .bi {
          font-size: 0.95rem;
          line-height: 1;
        }

        .scroll-crumb-toggle {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          margin-left: 0.4rem;
          flex: 0 0 auto;
          padding: 0.2rem 0.5rem 0.2rem 0.3rem;
          border: 0;
          background: transparent;
          color: var(--icon-soft);
          cursor: pointer;
          line-height: 1;
          transition: color 120ms ease;
        }

        .scroll-crumb-toggle:hover {
          color: var(--icon-strong);
        }

        .scroll-crumb-toggle:focus-visible {
          outline: 2px solid rgba(var(--signal-rgb), 0.35);
          outline-offset: 2px;
        }

        .scroll-crumb-toggle-icon {
          display: inline-flex;
          align-items: center;
          justify-content: center;
        }

        .scroll-crumb-toggle .icon-collapse {
          display: none;
        }

        .scroll-crumb.is-expanded .scroll-crumb-toggle .icon-expand {
          display: none;
        }

        .scroll-crumb.is-expanded .scroll-crumb-toggle .icon-collapse {
          display: inline-flex;
        }

        .scroll-crumb-toggle .bi {
          font-size: 0.95rem;
          line-height: 1;
          padding-right: 0.14rem;
        }

        .scroll-crumb-menu {
          margin-top: 0.55rem;
          padding: 0.8rem 0.85rem 0.9rem;
          border: 1px solid var(--overlay-border);
          border-radius: 1rem;
          background: var(--surface-overlay-strong);
          box-shadow: var(--shadow-glass), inset 0 1px 0 var(--overlay-highlight);
          backdrop-filter: blur(24px) saturate(145%);
          -webkit-backdrop-filter: blur(24px) saturate(145%);
          max-height: min(68vh, calc(100vh - 5.5rem));
          overflow-y: auto;
          overscroll-behavior: contain;
          -webkit-overflow-scrolling: touch;
          scrollbar-width: thin;
          scrollbar-color: var(--scrollbar-thumb-strong) transparent;
        }

        .scroll-crumb-menu[hidden] {
          display: none;
        }

        .scroll-crumb-menu::-webkit-scrollbar {
          width: 0.5rem;
        }

        .scroll-crumb-menu::-webkit-scrollbar-track {
          background: transparent;
        }

        .scroll-crumb-menu::-webkit-scrollbar-thumb {
          background: var(--scrollbar-thumb);
          border-radius: 999px;
        }

        .scroll-crumb-menu .contents {
          padding: 0;
          border: 0;
          border-radius: 0;
          background: transparent;
          box-shadow: none;
          backdrop-filter: none;
          -webkit-backdrop-filter: none;
        }

        .scroll-crumb-menu .contents a {
          display: block;
          padding: 0.28rem 0.4rem;
          border-radius: 0.55rem;
          transition: background 120ms ease, color 120ms ease;
        }

        .scroll-crumb-menu .contents a:hover,
        .scroll-crumb-menu .contents a:focus-visible {
          background: var(--hover-soft);
          outline: none;
        }

        .scroll-crumb-menu .contents a.is-current {
          background: var(--active-soft);
          color: var(--accent);
          font-weight: 600;
        }

        .scroll-crumb-menu .contents a.is-current .toc-number {
          color: var(--accent);
        }

        .scroll-crumb-menu .contents a.is-current-parent {
          background: var(--hover-faint);
          color: var(--ink);
        }

        .scroll-crumb-menu .contents .chapter-entry-link {
          display: flex;
          align-items: baseline;
          gap: 0.85rem;
        }

        .scroll-crumb-menu .contents .chapter-entry-number {
          flex: 0 0 auto;
          min-width: 3.1rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.72rem;
          font-weight: 600;
          letter-spacing: 0.06em;
          text-transform: uppercase;
        }

        .scroll-crumb-menu .contents .chapter-entry-title {
          flex: 1 1 auto;
          min-width: 0;
          color: inherit;
          font-size: 0.92rem;
          font-weight: 600;
          letter-spacing: -0.01em;
          line-height: 1.35;
        }

        .scroll-crumb-menu .contents .chapter-entry-link.is-current .chapter-entry-number,
        .scroll-crumb-menu .contents .chapter-entry-link.is-current .chapter-entry-title {
          color: var(--accent);
        }

        .theme-toggle {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 0.5rem;
          padding: 0.56rem 0.92rem;
          border: 1px solid transparent;
          border-radius: 999px;
          background: var(--surface-overlay);
          box-shadow: inset 0 1px 0 var(--overlay-highlight-soft);
          color: var(--icon-stronger);
          font-family: var(--font-ui);
          font-size: 0.75rem;
          font-weight: 500;
          letter-spacing: 0.01em;
          cursor: pointer;
          transition: background 120ms ease, color 120ms ease, box-shadow 120ms ease;
        }

        .theme-toggle:hover {
          background: var(--surface-overlay-strong);
          box-shadow: inset 0 1px 0 var(--overlay-highlight);
          color: var(--accent);
        }

        .theme-toggle:focus-visible {
          outline: 2px solid rgba(var(--signal-rgb), 0.35);
          outline-offset: 2px;
        }

        .theme-toggle .bi {
          font-size: 0.95rem;
          line-height: 1;
        }

        .navline-theme-toggle {
          margin-left: auto;
        }

        .scroll-crumb-theme-toggle {
          flex: 0 0 auto;
          width: 2rem;
          height: 2rem;
          padding: 0;
          border: 0;
          background: transparent;
          color: var(--icon-soft);
        }

        .scroll-crumb-theme-toggle:hover {
          background: var(--hover-medium);
          border-color: transparent;
          color: var(--icon-stronger);
        }

        .scroll-crumb-theme-toggle .theme-toggle-label {
          display: none;
        }

        .chapter-index {
          margin: 0;
          padding: 0;
          list-style: none;
        }

        .chapter-index li + li {
          margin-top: 0.12rem;
        }

        .chapter-index-link {
          display: flex;
          align-items: baseline;
          gap: 1.1rem;
          margin: 0 -0.65rem;
          padding: 0.98rem 0.65rem 1.02rem;
          border-radius: 1rem;
          text-decoration: none;
          color: inherit;
          transition: background 140ms ease, color 120ms ease;
        }

        .chapter-index-link:hover,
        .chapter-index-link:focus-visible {
          background: var(--hover-faint);
          outline: none;
          box-shadow: 0 0 0 2px rgba(var(--signal-rgb), 0.14);
        }

        .chapter-index-no {
          flex: 0 0 4rem;
          color: var(--muted);
          font-size: 0.72rem;
          font-weight: 500;
          letter-spacing: 0.03em;
        }

        .chapter-index-title {
          color: var(--accent);
          font-size: 1.04rem;
          font-weight: 500;
          letter-spacing: -0.01em;
          text-decoration: none;
          transition: color 120ms ease;
        }

        .chapter-index-link:hover .chapter-index-title,
        .chapter-index-link:focus-visible .chapter-index-title {
          color: rgba(var(--signal-rgb), 0.88);
        }

        .index-download {
          margin-top: 0.4rem;
          padding-top: 0.2rem;
        }

        .table-wrap {
          max-width: calc(var(--measure) + 8rem);
          margin: 1.2rem 0 1.4rem;
          overflow-x: auto;
          border-top: 1px solid var(--rule);
          border-bottom: 1px solid var(--rule);
          padding: 0.35rem 0;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          font-size: 1rem;
          line-height: 1.5;
        }

        thead th {
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
        }

        td,
        th {
          padding: 0.5rem 0.6rem 0.55rem 0;
          border-bottom: 1px solid var(--rule);
          vertical-align: top;
          text-align: left;
        }

        tbody tr:last-child td,
        tbody tr:last-child th {
          border-bottom: 0;
        }

        code {
          font-family: var(--font-mono);
          font-size: 0.84em;
          color: var(--code-ink);
          background: var(--code-bg);
          border: 1px solid var(--code-border);
          border-radius: 0.3rem;
          padding: 0.08rem 0.28rem;
        }

        em {
          font-style: italic;
        }

        .styr {
          position: relative;
          display: inline-block;
          margin: 0 0.02em;
          vertical-align: baseline;
          font-style: normal;
          white-space: nowrap;
        }

        .styr-form {
          font-weight: 600;
          letter-spacing: 0.015em;
        }

        .styr-tr {
          position: absolute;
          left: 50%;
          bottom: calc(100% + 0.3rem);
          transform: translateX(-50%);
          width: max-content;
          opacity: 0;
          pointer-events: none;
          z-index: 3;
          background: var(--surface-tooltip);
          border: 1px solid var(--tooltip-divider);
          border-radius: 0.3rem;
          padding: 0.24rem 0.5rem 0.22rem;
          box-shadow: 0 0.6rem 1.6rem rgba(0, 0, 0, 0.18);
          color: var(--tooltip-text);
          font-family: var(--font-ui);
          font-size: 0.7rem;
          font-style: normal;
          font-weight: 600;
          letter-spacing: 0.015em;
          line-height: 1.3;
          text-align: center;
          white-space: normal;
          max-width: min(14rem, calc(100vw - 2rem));
          transition: opacity 120ms ease;
          backdrop-filter: blur(12px) saturate(120%);
          -webkit-backdrop-filter: blur(12px) saturate(120%);
        }

        .styr-tr-text {
          display: inline;
        }

        .styr-gloss {
          display: inline;
          color: var(--tooltip-muted);
          font-size: 0.66rem;
          font-style: italic;
          font-weight: 500;
          letter-spacing: 0.01em;
          line-height: 1.4;
        }

        .styr-gloss::before {
          content: " \00b7  ";
          font-style: normal;
        }

        .styr:hover .styr-tr,
        .styr:focus-within .styr-tr {
          opacity: 1;
        }

        .has-selection .styr:hover .styr-tr,
        .has-selection .styr:focus-within .styr-tr {
          opacity: 0;
        }

        .table-wrap .styr {
          white-space: normal;
        }

        .table-wrap .styr-tr {
          white-space: normal;
        }

        .example {
          display: block;
          margin: 0.1rem 0 0.28rem;
        }

        .example-text {
          display: block;
          font-weight: 600;
        }

        .example-tr {
          display: block;
          margin-top: 0.18rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.78rem;
          font-style: normal;
          font-weight: 600;
          letter-spacing: 0.03em;
          line-height: 1.45;
        }

        @media (max-width: 980px) {
          .aside {
            order: -1;
          }

          .contents {
            padding: 1rem;
          }
        }

        /* ── <w ref> inflection tag shown inside hover bubble ───────── */

        .styr-infl-tag {
          display: block;
          margin-top: 0.12rem;
          font-size: 0.58rem;
          letter-spacing: 0.08em;
          text-transform: uppercase;
          color: var(--tooltip-muted);
        }

        .table-wrap .styr-infl-tag {
          margin-top: 0.08rem;
        }

        /* Graceful fallback for unresolved <w ref="…"> */
        .styr-missing .styr-form {
          color: var(--signal);
          opacity: 0.55;
          font-style: italic;
          font-weight: 400;
        }

        @media (max-width: 640px) {
          .page {
            width: min(calc(100vw - 1.4rem), var(--page-max));
            padding-top: 1.3rem;
          }

          .prose {
            font-size: 0.99rem;
            line-height: 1.66;
          }

          :root {
            --section-space: 2.6rem;
            --subsection-space: 1.75rem;
            --section-heading-gap: 1rem;
          }

          .navline {
            gap: 0.55rem 1rem;
          }


          .navline-theme-toggle {
            margin-left: 0;
          }

          .scroll-crumb {
            top: 0.55rem;
            width: min(calc(100vw - 0.8rem), var(--crumb-max));
          }

          .scroll-crumb-inner {
            min-height: 2.7rem;
            padding: 0.35rem 0.8rem 0.35rem 0.72rem;
          }

          .scroll-crumb-item {
            padding: 0.3rem 0.55rem;
          }

          .scroll-crumb-home {
            gap: 0.3rem;
            padding: 0 0.08rem 0 0.14rem;
          }

          .scroll-crumb-home-label {
            font-size: 0.72rem;
          }

          .scroll-crumb-kicker {
            font-size: 0.68rem;
            letter-spacing: 0.015em;
          }

          .scroll-crumb-current {
            font-size: 0.92rem;
          }

          .scroll-crumb-chapter-link {
            width: 1.85rem;
            height: 1.85rem;
          }

          .scroll-crumb-theme-toggle {
            width: 1.85rem;
            height: 1.85rem;
          }

          .scroll-crumb-menu {
            padding: 0.7rem 0.75rem 0.8rem;
            max-height: min(72vh, calc(100vh - 4.5rem));
          }

          .styr-tr {
            display: none;
          }
        }

        .dl-btn {
          display: flex;
          align-items: baseline;
          gap: 1.1rem;
          width: 100%;
          margin: 0 -0.65rem;
          padding: 0.98rem 0.65rem 1.02rem;
          border-radius: 1rem;
          background: none;
          border: none;
          color: inherit;
          font-family: var(--font-ui);
          cursor: pointer;
          text-align: left;
          transition: background 140ms ease;
        }

        .dl-btn:hover,
        .dl-btn:focus-visible {
          background: var(--hover-faint);
          outline: none;
          box-shadow: 0 0 0 2px rgba(var(--signal-rgb), 0.14);
        }

        .dl-btn::before {
          content: "↓";
          flex: 0 0 4rem;
          color: var(--muted);
          font-size: 0.72rem;
          font-weight: 500;
          letter-spacing: 0.03em;
        }

        .dl-btn-label {
          color: var(--accent);
          font-size: 1.04rem;
          font-weight: 500;
          letter-spacing: -0.01em;
          text-decoration: none;
          transition: color 120ms ease;
        }

        .dl-btn:hover .dl-btn-label,
        .dl-btn:focus-visible .dl-btn-label {
          color: rgba(var(--signal-rgb), 0.88);
        }

        .dl-btn:disabled {
          opacity: 0.4;
          cursor: not-allowed;
        }

        .dl-btn .bi {
          display: none;
        }

        .back-to-top {
          position: fixed;
          right: clamp(1rem, 3vw, 2rem);
          bottom: clamp(1rem, 3vw, 2rem);
          z-index: 180;
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.65rem 0.9rem;
          border: 1px solid var(--overlay-border);
          border-radius: 999px;
          background: var(--surface-float);
          box-shadow: var(--shadow-float), inset 0 1px 0 var(--overlay-highlight);
          color: var(--ink);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.02em;
          cursor: pointer;
          opacity: 0;
          visibility: hidden;
          pointer-events: none;
          transform: translateY(0.9rem);
          transition:
            opacity 160ms ease,
            transform 160ms ease,
            visibility 160ms ease,
            background 120ms ease,
            box-shadow 120ms ease,
            border-color 120ms ease;
          backdrop-filter: blur(18px) saturate(140%);
          -webkit-backdrop-filter: blur(18px) saturate(140%);
        }

        .back-to-top.is-visible {
          opacity: 1;
          visibility: visible;
          pointer-events: auto;
          transform: translateY(0);
        }

        body.lex-panel-active .back-to-top {
          opacity: 0;
          visibility: hidden;
          pointer-events: none;
          transform: translateY(0.9rem);
        }

        .back-to-top:hover {
          background: var(--surface-float-hover);
          border-color: var(--icon-soft);
          box-shadow: var(--shadow-float-hover);
        }

        .back-to-top:focus-visible {
          outline: 2px solid rgba(var(--signal-rgb), 0.4);
          outline-offset: 3px;
        }

        .back-to-top .bi {
          font-size: 0.95rem;
          flex-shrink: 0;
          line-height: 1;
        }

        @media (max-width: 640px) {
          .back-to-top {
            right: 0.75rem;
            bottom: 0.75rem;
            padding: 0.75rem;
          }

          .back-to-top-label {
            display: none;
          }
        }

        /* ── Clickable lexeme tokens ───────────────────────────── */

        .styr[data-ref] {
          cursor: pointer;
          border-bottom: 1px dotted rgba(var(--signal-rgb), 0.4);
          transition: border-color 150ms ease;
        }

        .styr[data-ref]:hover {
          border-bottom-color: rgba(var(--signal-rgb), 0.68);
        }

        /* ── Lexicon sidebar panel ─────────────────────────────── */

        .lex-overlay {
          position: fixed;
          inset: 0;
          z-index: 90;
          background: rgba(0, 0, 0, 0);
          backdrop-filter: blur(0px) saturate(100%);
          -webkit-backdrop-filter: blur(0px) saturate(100%);
          pointer-events: none;
          transition: background 200ms ease, backdrop-filter 200ms ease, -webkit-backdrop-filter 200ms ease;
        }

        .lex-overlay-visible {
          background: var(--overlay);
          backdrop-filter: blur(8px) saturate(110%);
          -webkit-backdrop-filter: blur(8px) saturate(110%);
          pointer-events: auto;
        }

        .lex-panel {
          position: fixed;
          top: 0;
          right: 0;
          bottom: 0;
          z-index: 100;
          width: min(22rem, 88vw);
          background: var(--surface-overlay-strong);
          border-left: 1px solid var(--overlay-border);
          box-shadow: var(--shadow-side);
          transform: translateX(100%);
          transition: transform 220ms cubic-bezier(0.4, 0, 0.2, 1);
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          backdrop-filter: blur(24px) saturate(145%);
          -webkit-backdrop-filter: blur(24px) saturate(145%);
        }

        .lex-panel-open {
          transform: translateX(0);
        }

        .lex-panel-header {
          display: flex;
          justify-content: flex-end;
          padding: 0.75rem 1rem 0;
        }

        .lex-panel-close {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          background: none;
          border: none;
          cursor: pointer;
          line-height: 1;
          color: var(--muted);
          padding: 0.2rem 0.4rem;
          border-radius: 0.25rem;
          transition: color 120ms ease;
          font-size: 1rem;
        }

        .lex-panel-close .bi {
          font-size: 1.35rem;
          line-height: 1;
        }

        .lex-panel-close:hover {
          color: var(--ink);
        }

        .lex-panel-body {
          padding: 0.5rem 1.25rem 2rem;
        }

        .lex-lemma {
          margin-bottom: 0.4rem;
        }

        .lex-lemma-cyr {
          display: block;
          font-family: var(--font-display);
          font-size: 1.5rem;
          font-weight: 600;
          letter-spacing: -0.03em;
          color: var(--accent);
        }

        .lex-lemma-tr {
          display: block;
          margin-top: 0.15rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.82rem;
          font-weight: 600;
          letter-spacing: 0.04em;
        }

        .lex-tags {
          margin-bottom: 0.55rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
        }

        .lex-gloss {
          margin-bottom: 1rem;
          font-size: 1rem;
          line-height: 1.55;
          color: var(--ink);
          font-style: italic;
        }

        .lex-forms {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.88rem;
          line-height: 1.5;
        }

        .lex-forms td {
          padding: 0.32rem 0.5rem 0.32rem 0;
          border-bottom: 1px solid var(--rule);
          vertical-align: top;
        }

        .lex-forms tbody tr:last-child td {
          border-bottom: 0;
        }

        .lex-form-label {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.05em;
          text-transform: uppercase;
          white-space: nowrap;
        }

        .lex-form-cyr {
          font-weight: 600;
        }

        .lex-form-tr {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.82rem;
          letter-spacing: 0.02em;
        }

        /* ── Collapsible forms section in panel ────────────────── */

        .lex-forms-section {
          margin-top: 1rem;
          padding-top: 0.75rem;
          border-top: 1px solid var(--rule);
        }

        .lex-forms-section summary {
          display: flex;
          align-items: center;
          gap: 0.4rem;
          cursor: pointer;
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          text-transform: uppercase;
          letter-spacing: 0.06em;
          color: var(--muted);
          list-style: none;
          user-select: none;
          margin-bottom: 0.5rem;
        }

        .lex-forms-section summary::-webkit-details-marker {
          display: none;
        }

        .lex-forms-section summary::before {
          content: '\25b8';
          display: inline-block;
          font-size: 0.68rem;
          transition: transform 150ms ease;
        }

        .lex-forms-section[open] summary::before {
          transform: rotate(90deg);
        }

        /* ── Loci list in panel ─────────────────────────────────── */

        .lex-loci-section {
          margin-top: 1.1rem;
          padding-top: 0.75rem;
          border-top: 1px solid var(--rule);
        }

        .lex-loci-section summary {
          display: flex;
          align-items: center;
          gap: 0.4rem;
          cursor: pointer;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
          list-style: none;
          user-select: none;
        }

        .lex-loci-section summary::-webkit-details-marker {
          display: none;
        }

        .lex-loci-section summary::before {
          content: '\25b8';
          display: inline-block;
          font-size: 0.68rem;
          transition: transform 150ms ease;
        }

        .lex-loci-section[open] summary::before {
          transform: rotate(90deg);
        }

        .lex-loci-section .lex-loci-count {
          font-weight: 600;
          color: var(--muted);
          opacity: 0.7;
        }

        .lex-loci-heading {
          margin: 1.3rem 0 0.55rem;
          padding-top: 0.85rem;
          border-top: 1px solid var(--rule);
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
        }

        .lex-loci {
          list-style: none;
          margin: 0;
          padding: 0;
        }

        .lex-loci li {
          margin: 0;
        }

        .lex-locus {
          display: block;
          padding: 0.5rem 0.55rem;
          margin: 0 -0.55rem;
          border-radius: 0.3rem;
          text-decoration: none;
          color: inherit;
          cursor: pointer;
          transition: background 120ms ease;
        }

        .lex-locus:hover {
          background: var(--accent-soft);
        }

        .lex-locus-section {
          display: block;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.01em;
          margin-bottom: 0.18rem;
        }

        .lex-locus-context {
          display: block;
          font-size: 0.84rem;
          line-height: 1.5;
          color: var(--ink);
        }

        .lex-locus-context .lex-locus-hit {
          color: inherit;
          font-weight: 600;
          background: rgba(var(--mark-rgb), 0.55);
          border-radius: 0.18rem;
          box-decoration-break: clone;
          -webkit-box-decoration-break: clone;
          padding: 0 0.12rem;
        }

        .lex-locus-context .lex-locus-fade {
          color: var(--muted);
        }

        .styr.lex-highlight {
          background: rgba(var(--mark-rgb), 0.34);
          border-radius: 0.2rem;
          outline: 1.5px solid rgba(var(--signal-rgb), 0.24);
          outline-offset: 1px;
          transition: outline-color 600ms ease, background 600ms ease;
        }

        @media (min-width: 1100px) {
          :root {
            --crumb-max: min(55vw, 54rem);
          }
        }

        @media (max-width: 640px) {
          .lex-panel {
            width: 100vw;
          }
        }

        /* ── Selection highlight override ───────────────────────── */

        ::selection {
          background: rgba(var(--mark-rgb), 0.5);
          color: inherit;
        }

        ::-moz-selection {
          background: rgba(var(--mark-rgb), 0.5);
          color: inherit;
        }

        /* ── Copy popup ────────────────────────────────────────── */

        .copy-popup {
          position: fixed;
          z-index: 200;
          display: flex;
          align-items: center;
          gap: 0.35rem;
          left: 50%;
          bottom: 1rem;
          background: var(--surface-popup);
          border: 1px solid var(--popup-divider);
          border-radius: 0.35rem;
          box-shadow: var(--shadow-popup);
          padding: 0.3rem;
          max-width: calc(100vw - 1rem);
          opacity: 0;
          transform: translateX(-50%) translateY(0.4rem);
          pointer-events: none;
          visibility: hidden;
          transition: opacity 120ms ease, transform 120ms ease;
          overflow: hidden;
          backdrop-filter: blur(20px) saturate(140%);
          -webkit-backdrop-filter: blur(20px) saturate(140%);
        }

        .copy-popup-visible {
          opacity: 0.96;
          transform: translateX(-50%) translateY(0);
          pointer-events: auto;
          visibility: visible;
        }

        .copy-popup-copied .copy-popup-btn {
          display: none;
        }

        .copy-popup-failed .copy-popup-btn {
          display: none;
        }

        .copy-popup-confirm {
          display: none;
          align-items: center;
          gap: 0.35rem;
          padding: 0.38rem 0.65rem;
          color: var(--popup-text);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
        }

        .copy-popup-copied .copy-popup-confirm {
          display: flex;
        }

        .copy-popup-confirm .bi {
          flex-shrink: 0;
          line-height: 1;
        }

        .copy-popup-hint {
          display: none;
          padding: 0 0.45rem 0 0.2rem;
          color: var(--popup-text-muted);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
        }

        .copy-popup-idle .copy-popup-hint {
          display: block;
        }

        .copy-popup-error {
          display: none;
          align-items: center;
          padding: 0.38rem 0.65rem;
          color: var(--danger-text);
          background: var(--danger-surface);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
        }

        .copy-popup-failed .copy-popup-error {
          display: flex;
        }

        .copy-popup-btn {
          position: relative;
          display: flex;
          align-items: center;
          gap: 0.35rem;
          padding: 0.38rem 0.65rem;
          border: none;
          background: transparent;
          color: var(--popup-text-soft);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
          cursor: pointer;
          opacity: 0.78;
          transition: color 100ms ease, opacity 100ms ease;
        }

        .copy-popup-btn:disabled {
          cursor: default;
          opacity: 0.45;
        }

        .copy-popup-btn:hover {
          background: transparent;
          color: var(--popup-text);
          opacity: 1;
        }

        .copy-popup-btn:disabled:hover {
          background: transparent;
          color: var(--popup-text-soft);
          opacity: 0.45;
        }

        .copy-popup-btn + .copy-popup-btn {
          border-left: 1px solid var(--popup-divider);
        }

        .copy-popup-btn .bi {
          flex-shrink: 0;
          font-size: 0.85rem;
          line-height: 1;
        }

        @media (max-width: 640px) {
          .copy-popup {
            left: 0.5rem;
            right: 0.5rem;
            bottom: 0.5rem;
            transform: none;
            flex-wrap: wrap;
            justify-content: center;
          }
        }
      ]]></style>
    </head>
  </xsl:template>

  <xsl:template match="grammar">
    <html lang="en">
      <xsl:call-template name="document-head">
        <xsl:with-param name="title" select="@t"/>
      </xsl:call-template>
      <body>
        <div class="page" id="top">
          <header class="masthead">
            <div class="chapter-masthead-body">
              <p class="eyebrow"><xsl:value-of select="@language"/></p>
              <h1><xsl:value-of select="@t"/></h1>
              <div class="navline">
                <button class="theme-toggle navline-theme-toggle" type="button" data-theme-toggle="full" data-theme-label-prefix="Theme">
                  <i class="bi bi-circle-half" data-theme-icon="true" aria-hidden="true"></i>
                  <span class="theme-toggle-label" data-theme-label="true">Theme: Auto</span>
                </button>
              </div>
            </div>
          </header>

          <main class="layout chapter-layout">
            <div class="main">
              <ol class="chapter-index">
                <xsl:apply-templates select="ch" mode="contents-card"/>
              </ol>
              <section class="index-download" aria-label="Download">
                <button class="dl-btn" id="dl-all" type="button">
                  <span class="dl-btn-label">Download full grammar</span>
                </button>
              </section>
            </div>
          </main>
        </div>
        <button class="back-to-top" id="back-to-top" type="button" aria-label="Back to top">
          <i class="bi bi-arrow-bar-up" aria-hidden="true"></i>
          <span class="back-to-top-label">Back to top</span>
        </button>
        <script src="markup.js"></script>
        <script src="theme-toggle.js"></script>
        <script src="transliteration.js"></script>
        <script src="back-to-top.js"></script>
        <script src="lexicon-panel.js"></script>
        <script src="copy-popup.js"></script>
        <script src="download.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="ch">
    <xsl:variable name="contents" select="document('index.xml')/grammar"/>
    <xsl:variable name="current-entry" select="$contents/ch[@id = current()/@id]"/>
    <xsl:variable name="previous-entry" select="$current-entry/preceding-sibling::ch[1]"/>
    <xsl:variable name="next-entry" select="$current-entry/following-sibling::ch[1]"/>

    <html lang="en">
      <xsl:call-template name="document-head">
        <xsl:with-param name="title" select="@t"/>
      </xsl:call-template>
      <body>
        <div class="page" id="top">
          <header class="masthead">
            <div class="chapter-masthead-body">
              <p class="eyebrow">Chapter <xsl:value-of select="@id"/></p>
              <h1><xsl:value-of select="@t"/></h1>
              <div class="navline">
                <a href="index.xml">Contents</a>
                <xsl:if test="$previous-entry">
                  <a href="{$previous-entry/@file}">Previous: <xsl:value-of select="$previous-entry/@t"/></a>
                </xsl:if>
                <xsl:if test="$next-entry">
                  <a href="{$next-entry/@file}">Next: <xsl:value-of select="$next-entry/@t"/></a>
                </xsl:if>
                <button class="theme-toggle navline-theme-toggle" type="button" data-theme-toggle="full" data-theme-label-prefix="Theme">
                  <i class="bi bi-circle-half" data-theme-icon="true" aria-hidden="true"></i>
                  <span class="theme-toggle-label" data-theme-label="true">Theme: Auto</span>
                </button>
              </div>
            </div>
          </header>

          <main class="layout chapter-layout">
            <article class="main prose">
              <xsl:apply-templates select="node()"/>
            </article>
          </main>
        </div>
        <div class="scroll-crumb" id="scroll-crumb" aria-hidden="true">
          <nav class="scroll-crumb-inner" aria-label="Current section">
            <button class="scroll-crumb-item scroll-crumb-home" id="scroll-crumb-home-toggle" type="button" aria-expanded="false" aria-controls="scroll-crumb-chapter-menu" aria-label="Browse chapters">
              <i class="bi bi-book" aria-hidden="true"></i>
              <span class="scroll-crumb-home-label">Browse chapters</span>
            </button>
            <span class="scroll-crumb-kicker" id="scroll-crumb-kicker" hidden="hidden"></span>
            <a class="scroll-crumb-item scroll-crumb-current" id="scroll-crumb-current" href="#top"></a>
            <xsl:if test="$previous-entry">
              <a class="scroll-crumb-item scroll-crumb-chapter-link" href="{$previous-entry/@file}" aria-label="Previous chapter: {$previous-entry/@t}" title="Previous chapter: {$previous-entry/@t}">
                <i class="bi bi-chevron-left" aria-hidden="true"></i>
              </a>
            </xsl:if>
            <xsl:if test="$next-entry">
              <a class="scroll-crumb-item scroll-crumb-chapter-link" href="{$next-entry/@file}" aria-label="Next chapter: {$next-entry/@t}" title="Next chapter: {$next-entry/@t}">
                <i class="bi bi-chevron-right" aria-hidden="true"></i>
              </a>
            </xsl:if>
            <button class="theme-toggle scroll-crumb-theme-toggle" type="button" data-theme-toggle="compact" data-theme-label-prefix="Theme">
              <i class="bi bi-circle-half" data-theme-icon="true" aria-hidden="true"></i>
              <span class="theme-toggle-label" data-theme-label="true">Theme: Auto</span>
            </button>
            <button class="scroll-crumb-toggle" id="scroll-crumb-toggle" type="button" aria-expanded="false" aria-controls="scroll-crumb-menu" aria-label="Open page contents">
              <span class="scroll-crumb-toggle-icon icon-expand" aria-hidden="true">
                <i class="bi bi-chevron-down"></i>
              </span>
              <span class="scroll-crumb-toggle-icon icon-collapse" aria-hidden="true">
                <i class="bi bi-chevron-up"></i>
              </span>
            </button>
          </nav>
          <div class="scroll-crumb-menu" id="scroll-crumb-chapter-menu" hidden="hidden">
            <ol class="contents">
              <li>
                <a class="chapter-entry-link" href="index.xml">
                  <span class="chapter-entry-number">Index</span>
                  <span class="chapter-entry-title">Full Contents</span>
                </a>
              </li>
              <xsl:apply-templates select="$contents/ch" mode="chapter-crumb-toc">
                <xsl:with-param name="current-id" select="@id"/>
              </xsl:apply-templates>
            </ol>
          </div>
          <div class="scroll-crumb-menu" id="scroll-crumb-menu" hidden="hidden">
            <ol class="contents">
              <xsl:apply-templates select="sec" mode="section-toc"/>
            </ol>
          </div>
        </div>
        <button class="back-to-top" id="back-to-top" type="button" aria-label="Back to top">
          <i class="bi bi-arrow-bar-up" aria-hidden="true"></i>
          <span class="back-to-top-label">Back to top</span>
        </button>
        <script src="theme-toggle.js"></script>
        <script src="transliteration.js"></script>
        <script src="back-to-top.js"></script>
        <script src="scroll-crumb.js"></script>
        <script src="lexicon-panel.js"></script>
        <script src="copy-popup.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="ch" mode="contents-card">
    <li>
      <a class="chapter-index-link" href="{@file}">
        <span class="chapter-index-no">Ch. <xsl:value-of select="@id"/></span>
        <span class="chapter-index-title"><xsl:value-of select="@t"/></span>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="sec" mode="section-toc">
    <li>
      <a href="#sec-{count(preceding::sec) + 1}">
        <span class="toc-number"><xsl:number level="single" count="sec"/></span>
        <xsl:value-of select="@t"/>
      </a>
      <xsl:if test="sub">
        <ol class="toc-sublist">
          <xsl:apply-templates select="sub" mode="section-toc"/>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="ch" mode="chapter-crumb-toc">
    <xsl:param name="current-id"/>
    <li>
      <a href="{@file}">
        <xsl:attribute name="class">
          <xsl:text>chapter-entry-link</xsl:text>
          <xsl:if test="@id = $current-id">
            <xsl:text> is-current</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <span class="chapter-entry-number">Ch. <xsl:value-of select="@id"/></span>
        <span class="chapter-entry-title"><xsl:value-of select="@t"/></span>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="sub" mode="section-toc">
    <li>
      <a href="#subsec-{count(preceding::sub) + 1}">
        <span class="toc-number"><xsl:number level="multiple" count="sec | sub" format="1.1"/></span>
        <xsl:value-of select="@t"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="list">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>

  <xsl:template match="item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="sec">
    <section id="sec-{count(preceding::sec) + 1}">
      <xsl:attribute name="data-number"><xsl:number level="single" count="sec"/></xsl:attribute>
      <xsl:attribute name="data-title"><xsl:value-of select="@t"/></xsl:attribute>
      <h2>
        <span class="section-number"><xsl:number level="single" count="sec"/></span>
        <xsl:value-of select="@t"/>
      </h2>
      <xsl:apply-templates select="node()"/>
    </section>
  </xsl:template>

  <xsl:template match="sub">
    <div class="subsection" id="subsec-{count(preceding::sub) + 1}">
      <xsl:attribute name="data-number"><xsl:number level="multiple" count="sec | sub" format="1.1"/></xsl:attribute>
      <xsl:attribute name="data-title"><xsl:value-of select="@t"/></xsl:attribute>
      <h3>
        <span class="section-number"><xsl:number level="multiple" count="sec | sub" format="1.1"/></span>
        <xsl:value-of select="@t"/>
      </h3>
      <xsl:apply-templates select="node()"/>
    </div>
  </xsl:template>

  <xsl:template match="tb">
    <div class="table-wrap">
      <table>
        <xsl:choose>
          <xsl:when test="r[1][not(descendant::em or descendant::st or descendant::code or descendant::i)]">
            <thead>
              <tr>
                <xsl:apply-templates select="r[1]/c" mode="header-cell"/>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates select="r[position() &gt; 1]"/>
            </tbody>
          </xsl:when>
          <xsl:otherwise>
            <tbody>
              <xsl:apply-templates select="r"/>
            </tbody>
          </xsl:otherwise>
        </xsl:choose>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="r">
    <tr><xsl:apply-templates select="c"/></tr>
  </xsl:template>

  <xsl:template match="c">
    <td><xsl:apply-templates/></td>
  </xsl:template>

  <xsl:template match="c" mode="header-cell">
    <th><xsl:apply-templates/></th>
  </xsl:template>

  <xsl:template match="ex">
    <span class="example">
      <span class="example-text"><xsl:apply-templates/></span>
      <xsl:if test="@tr and string-length(@tr) &gt; 0">
        <span class="example-tr">
          <xsl:attribute name="data-explicit-tr"><xsl:value-of select="@tr"/></xsl:attribute>
          <xsl:value-of select="@tr"/>
        </span>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="st">
    <xsl:variable name="show-token-tr" select="true()"/>
    <span class="styr">
      <xsl:attribute name="data-cyr"><xsl:value-of select="@v"/></xsl:attribute>
      <xsl:if test="@tr and string-length(@tr) &gt; 0">
        <xsl:attribute name="data-tr-explicit"><xsl:value-of select="@tr"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$show-token-tr">
        <xsl:attribute name="data-tr"><xsl:value-of select="@tr"/></xsl:attribute>
      </xsl:if>
      <span class="styr-form"><xsl:value-of select="@v"/></span>
      <xsl:if test="$show-token-tr and @tr and string-length(@tr) &gt; 0">
        <span class="styr-tr">
          <span class="styr-tr-text"><xsl:value-of select="@tr"/></span>
        </span>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="em">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="code">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="i">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="br">
    <br/>
  </xsl:template>

  <!-- ═══════════════════════════════════════════════════════════
       Lexicon form resolver
       Prefers explicit <form> values, then falls back to a template
       (verb-template, noun-template, or adjective-template) plus named
       stems when a lexeme declares @template.
       ═══════════════════════════════════════════════════════════ -->

  <xsl:template name="resolve-lex-form">
    <xsl:param name="entry"/>
    <xsl:param name="form-id"/>
    <xsl:param name="lexdoc" select="document($lexicon-uri)/lexicon"/>
    <xsl:variable name="canonical-form-id">
      <xsl:call-template name="canonical-infl">
        <xsl:with-param name="infl" select="$form-id"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$entry/form[@f = $canonical-form-id]">
        <xsl:value-of select="$entry/form[@f = $canonical-form-id][1]/@v"/>
      </xsl:when>
      <xsl:when test="string-length($entry/@template) &gt; 0">
        <xsl:variable name="pattern" select="$lexdoc/templates/*[@id = $entry/@template]/form[@f = $canonical-form-id][1]"/>
        <xsl:if test="$pattern">
          <xsl:variable name="stem-name" select="string($pattern/@stem)"/>
          <xsl:variable name="stem-value">
            <xsl:choose>
              <xsl:when test="string-length($stem-name) &gt; 0 and $entry/stem[@name = $stem-name]">
                <xsl:value-of select="$entry/stem[@name = $stem-name][1]/@v"/>
              </xsl:when>
              <xsl:when test="$entry/stem[@name = 'main']">
                <xsl:value-of select="$entry/stem[@name = 'main'][1]/@v"/>
              </xsl:when>
              <xsl:when test="$entry/stem[1]">
                <xsl:value-of select="$entry/stem[1]/@v"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="concat(string($pattern/@prefix), $stem-value, string($pattern/@suffix))"/>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="canonical-infl">
    <xsl:param name="infl"/>

    <xsl:choose>
      <xsl:when test="$infl = '1s'">1sg</xsl:when>
      <xsl:when test="$infl = '2s'">2sg</xsl:when>
      <xsl:when test="$infl = '3s'">3sg</xsl:when>
      <xsl:when test="$infl = '1p'">1pl</xsl:when>
      <xsl:when test="$infl = '2p'">2pl</xsl:when>
      <xsl:when test="$infl = '3p'">3pl</xsl:when>
      <xsl:when test="$infl = 'pp'">ppl</xsl:when>
      <xsl:when test="$infl = 'l.m'">lptc.m</xsl:when>
      <xsl:when test="$infl = 'l.f'">lptc.f</xsl:when>
      <xsl:when test="$infl = 'l.n'">lptc.n</xsl:when>
      <xsl:when test="$infl = 'l.p'">lptc.pl</xsl:when>
      <xsl:when test="$infl = 'imp.2s'">imp.2sg</xsl:when>
      <xsl:when test="$infl = 'imp.2p'">imp.2pl</xsl:when>
      <xsl:when test="$infl = 'nom.s'">nom.sg</xsl:when>
      <xsl:when test="$infl = 'o.s'">obl.sg</xsl:when>
      <xsl:when test="$infl = 'm.s'">m.sg</xsl:when>
      <xsl:when test="$infl = 'f.s'">f.sg</xsl:when>
      <xsl:when test="$infl = 'n.s'">n.sg</xsl:when>
      <xsl:when test="$infl = 'm.o.s'">m.sg.obl</xsl:when>
      <xsl:when test="$infl = 'f.o.s'">f.sg.obl</xsl:when>
      <xsl:when test="$infl = 'o.f.s' or $infl = 'obl.f.sg'">f.sg.obl</xsl:when>
      <xsl:when test="$infl = 'n.o.s'">n.sg.obl</xsl:when>
      <xsl:when test="$infl = 'o.p' or $infl = 'o.pl'">pl.obl</xsl:when>
      <xsl:when test="$infl = 'o'">obl</xsl:when>
      <xsl:when test="$infl = 'b'">base</xsl:when>
      <xsl:otherwise><xsl:value-of select="$infl"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ═══════════════════════════════════════════════════════════
       <w ref="…" infl="…"/> — lexeme reference
       Looks up the entry in lexicon.xml and renders an <st>-equivalent
       span.  If @infl is given, the matching <form @f> is used; otherwise
       the default form is: inf for verbs, nom.sg for nouns, m.sg for
       adjectives, form[1] for all others.  An optional inflection badge
       appears inside the hover bubble.
       ═══════════════════════════════════════════════════════════ -->

  <xsl:template match="w">
    <xsl:variable name="ref"   select="@ref"/>
    <xsl:variable name="infl"  select="@infl"/>
    <xsl:variable name="infl-canon">
      <xsl:call-template name="canonical-infl">
        <xsl:with-param name="infl" select="$infl"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lexdoc" select="document($lexicon-uri)/lexicon"/>
    <xsl:variable name="entry" select="$lexdoc/lex[@id = $ref]"/>

    <xsl:choose>

      <!-- ── Pre-resolved by download.js (@v/@lemma/@gloss set in JS before transform) ──
           Browsers block document() inside XSLTProcessor, so the download
           button pre-resolves <w> elements by setting @v (display form),
           @lemma, and @gloss before calling transformToDocument().  This
           branch handles those elements and produces identical output to the
           found-entry branch without needing document().
      ──────────────────────────────────────────────────────────────── -->
      <xsl:when test="string-length(@v) &gt; 0">
        <xsl:variable name="pre-fv" select="string(@v)"/>
        <xsl:variable name="pre-lemma">
          <xsl:choose>
            <xsl:when test="string-length(@lemma) &gt; 0"><xsl:value-of select="@lemma"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@v"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pre-gloss" select="string(@gloss)"/>
        <span class="styr">
          <xsl:attribute name="data-cyr"><xsl:value-of select="$pre-fv"/></xsl:attribute>
          <xsl:attribute name="data-lemma"><xsl:value-of select="$pre-lemma"/></xsl:attribute>
          <xsl:if test="string-length($pre-gloss) &gt; 0">
            <xsl:attribute name="data-gloss"><xsl:value-of select="$pre-gloss"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="string-length($infl-canon) &gt; 0">
            <xsl:attribute name="data-infl"><xsl:value-of select="$infl-canon"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="data-ref"><xsl:value-of select="$ref"/></xsl:attribute>
          <span class="styr-form"><xsl:value-of select="$pre-fv"/></span>
          <span class="styr-tr">
            <span class="styr-tr-text"/>
            <xsl:if test="string-length($pre-gloss) &gt; 0">
              <span class="styr-gloss"><xsl:value-of select="$pre-gloss"/></span>
            </xsl:if>
            <xsl:if test="string-length($infl-canon) &gt; 0">
              <span class="styr-infl-tag">
                <xsl:value-of select="$infl-canon"/>
                <xsl:if test="not($pre-fv = $pre-lemma)">
                  <xsl:text> · </xsl:text>
                  <xsl:value-of select="$pre-lemma"/>
                </xsl:if>
              </span>
            </xsl:if>
          </span>
        </span>
      </xsl:when>

      <!-- ── Entry found ──────────────────────────────────────── -->
      <xsl:when test="$entry">

        <xsl:variable name="requested-v">
          <xsl:if test="string-length($infl-canon) &gt; 0">
            <xsl:call-template name="resolve-lex-form">
              <xsl:with-param name="entry" select="$entry"/>
              <xsl:with-param name="form-id" select="$infl-canon"/>
              <xsl:with-param name="lexdoc" select="$lexdoc"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="default-v">
          <xsl:choose>
            <xsl:when test="$entry/@pos = 'v'">
              <xsl:variable name="verb-inf">
                <xsl:call-template name="resolve-lex-form">
                  <xsl:with-param name="entry" select="$entry"/>
                  <xsl:with-param name="form-id" select="'inf'"/>
                  <xsl:with-param name="lexdoc" select="$lexdoc"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="string-length($verb-inf) &gt; 0">
                  <xsl:value-of select="$verb-inf"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entry/form[1]/@v"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$entry/@pos = 'n'">
              <xsl:variable name="noun-nom">
                <xsl:call-template name="resolve-lex-form">
                  <xsl:with-param name="entry" select="$entry"/>
                  <xsl:with-param name="form-id" select="'nom.sg'"/>
                  <xsl:with-param name="lexdoc" select="$lexdoc"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="string-length($noun-nom) &gt; 0">
                  <xsl:value-of select="$noun-nom"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entry/form[1]/@v"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$entry/@pos = 'adj'">
              <xsl:variable name="adj-m">
                <xsl:call-template name="resolve-lex-form">
                  <xsl:with-param name="entry" select="$entry"/>
                  <xsl:with-param name="form-id" select="'m.sg'"/>
                  <xsl:with-param name="lexdoc" select="$lexdoc"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="string-length($adj-m) &gt; 0">
                  <xsl:value-of select="$adj-m"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entry/form[1]/@v"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entry/form[1]/@v"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Pick the displayed form value -->
        <xsl:variable name="fv">
          <xsl:choose>
            <xsl:when test="string-length($requested-v) &gt; 0">
              <xsl:value-of select="$requested-v"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$default-v"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Lemma form (first form) for the infl-tag label -->
        <xsl:variable name="lemma-v" select="$default-v"/>
        <xsl:variable name="gloss" select="string($entry/@gloss)"/>
        <xsl:variable name="show-token-tr" select="true()"/>

        <!-- @cap="1": capitalise the first letter of the rendered form
             and its transliteration (sentence-initial position).           -->
        <xsl:variable name="display-v">
          <xsl:choose>
            <xsl:when test="@cap = '1'">
              <xsl:value-of select="concat(
                translate(substring($fv, 1, 1),
                  'абвгдежзийіїклмнопрстуфхцчшӑюя',
                  'АБВГДЕЖЗИЙІЇКЛМНОПРСТУФХЦЧШӐЮЯ'),
                substring($fv, 2))"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$fv"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <span class="styr">
          <xsl:attribute name="data-cyr"><xsl:value-of select="$display-v"/></xsl:attribute>
          <xsl:attribute name="data-lemma"><xsl:value-of select="$lemma-v"/></xsl:attribute>
          <xsl:if test="string-length($gloss) &gt; 0">
            <xsl:attribute name="data-gloss"><xsl:value-of select="$gloss"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="string-length($infl-canon) &gt; 0">
            <xsl:attribute name="data-infl"><xsl:value-of select="$infl-canon"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$show-token-tr">
            <xsl:attribute name="data-ref"><xsl:value-of select="$ref"/></xsl:attribute>
          </xsl:if>

          <span class="styr-form"><xsl:value-of select="$display-v"/></span>

          <!-- Hover bubble: transliteration + optional infl badge -->
          <xsl:if test="$show-token-tr">
            <span class="styr-tr">
              <span class="styr-tr-text"/>
              <xsl:if test="string-length($gloss) &gt; 0">
                <span class="styr-gloss">
                  <xsl:value-of select="$gloss"/>
                </span>
              </xsl:if>
              <!-- Infl badge: only when an explicit @infl was requested -->
              <xsl:if test="string-length($infl-canon) &gt; 0">
                <span class="styr-infl-tag">
                  <xsl:value-of select="$infl-canon"/>
                  <!-- Append "· lemma" only when the inflected form ≠ lemma -->
                  <xsl:if test="not($fv = $lemma-v)">
                    <xsl:text> · </xsl:text>
                    <xsl:value-of select="$lemma-v"/>
                  </xsl:if>
                </span>
              </xsl:if>
            </span>
          </xsl:if>
        </span>
      </xsl:when>

      <!-- ── Entry not found: render a visible placeholder ───── -->
      <xsl:otherwise>
        <span class="styr styr-missing">
          <xsl:attribute name="aria-label">
            <xsl:text>lexicon entry not found: </xsl:text>
            <xsl:value-of select="$ref"/>
          </xsl:attribute>
          <span class="styr-form">
            <xsl:text>[?</xsl:text>
            <xsl:value-of select="$ref"/>
            <xsl:text>]</xsl:text>
          </span>
        </span>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
