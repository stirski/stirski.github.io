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
      <title><xsl:value-of select="$title"/></title>
      <link rel="preconnect" href="https://fonts.googleapis.com"/>
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Sans+3:wght@400;500;600;700&amp;display=swap"/>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"/>
      <style type="text/css"><![CDATA[
        :root {
          --paper: #ffffff;
          --ink: #111111;
          --muted: #888888;
          --rule: #e8e8e8;
          --accent: #111111;
          --accent-soft: #f4f4f4;
          --signal: #c0392b;
          --font-body: "Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-display: "Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-ui: "Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-mono: "SFMono-Regular", "Cascadia Mono", Consolas, monospace;
          --page-max: 64rem;
          --measure: 42rem;
          --margin-col: 13.5rem;
          --layout-gap: 2rem;
        }


        html {
          scroll-behavior: smooth;
        }

        body {
          margin: 0;
          background:
            linear-gradient(180deg, #ffffff 0%, #fbfbfb 22rem, #ffffff 100%);
          color: var(--ink);
          font-family: var(--font-body);
          font-optical-sizing: auto;
          text-rendering: optimizeLegibility;
          -webkit-font-smoothing: antialiased;
          font-kerning: normal;
          font-variant-numeric: lining-nums proportional-nums;
          letter-spacing: -0.01em;
        }

        a {
          color: inherit;
          text-decoration-color: rgba(192, 57, 43, 0.28);
          text-underline-offset: 0.16em;
        }

        a:hover {
          text-decoration-color: rgba(192, 57, 43, 0.7);
        }

        .page {
          width: min(calc(100vw - 2.5rem), var(--page-max));
          margin: 0 auto;
          padding: clamp(1.6rem, 4vw, 2.5rem) 0 4rem;
        }

        .masthead {
          padding: 0 0 1.15rem;
          border-bottom: 1px solid var(--rule);
          margin-bottom: 1.75rem;
        }

        .eyebrow {
          margin: 0 0 0.45rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.1em;
          text-transform: uppercase;
        }

        h1,
        h2,
        h3 {
          margin: 0;
          font-family: var(--font-display);
          font-weight: 700;
          line-height: 1;
          color: var(--accent);
          text-wrap: balance;
        }

        h1 {
          max-width: 14ch;
          font-size: clamp(2.1rem, 4vw, 3.25rem);
          letter-spacing: -0.035em;
        }

        .deck {
          max-width: 30rem;
          margin: 0.85rem 0 0;
          color: var(--muted);
          font-size: 1.08rem;
          line-height: 1.55;
        }

        .navline {
          display: flex;
          flex-wrap: wrap;
          gap: 0.9rem 1.35rem;
          margin-top: 1rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.75rem;
          font-weight: 500;
          letter-spacing: 0.04em;
          text-transform: uppercase;
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
          max-width: min(100%, calc(var(--measure) + 2rem));
        }

        .prose {
          hanging-punctuation: first last;
          hyphens: auto;
          font-size: 1.12rem;
          line-height: 1.64;
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

        .prose section {
          margin-top: 2.3rem;
        }

        .prose .subsection {
          margin-top: 1.4rem;
        }

        .prose section[id],
        .prose .subsection[id] {
          scroll-margin-top: 5.5rem;
        }

        .prose h2 {
          max-width: var(--measure);
          margin: 0 0 1rem;
          padding-top: 1.4rem;
          border-top: 1px solid var(--rule);
          font-size: clamp(1.5rem, 2.5vw, 1.95rem);
          font-weight: 700;
          letter-spacing: -0.03em;
        }

        .prose h3 {
          max-width: var(--measure);
          margin: 0 0 0.72rem;
          font-size: clamp(1.2rem, 2vw, 1.5rem);
          font-weight: 600;
          letter-spacing: -0.025em;
        }

        .section-number {
          display: inline-block;
          margin-right: 0.55rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.68em;
          font-weight: 500;
          letter-spacing: 0.06em;
        }

        .contents {
          margin: 0;
          padding: 1rem 1rem 1.05rem;
          list-style: none;
          border: 1px solid var(--rule);
          border-radius: 0.9rem;
          background: rgba(255, 255, 255, 0.86);
          box-shadow: 0 16px 40px rgba(17, 17, 17, 0.04);
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
          width: min(calc(100vw - 1.5rem), 56rem);
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
          display: flex;
          align-items: center;
          gap: 0.45rem;
          min-height: 3rem;
          padding: 0.45rem 0.55rem;
          border: 1px solid rgba(17, 17, 17, 0.08);
          border-radius: 999px;
          background: rgba(255, 255, 255, 0.72);
          box-shadow: 0 20px 44px rgba(17, 17, 17, 0.08);
          backdrop-filter: blur(18px) saturate(150%);
          -webkit-backdrop-filter: blur(18px) saturate(150%);
          overflow-x: auto;
          scrollbar-width: none;
        }

        .scroll-crumb-inner::-webkit-scrollbar {
          display: none;
        }

        .scroll-crumb-item {
          display: inline-flex;
          align-items: center;
          min-width: 0;
          padding: 0.35rem 0.7rem;
          border-radius: 999px;
          text-decoration: none;
          white-space: nowrap;
          transition: background 120ms ease, color 120ms ease;
        }

        .scroll-crumb-item:hover {
          background: rgba(17, 17, 17, 0.05);
        }

        .scroll-crumb-home {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.74rem;
          font-weight: 600;
          letter-spacing: 0.04em;
          text-transform: uppercase;
        }

        .scroll-crumb-chapter {
          color: var(--muted);
          font-size: 0.95rem;
        }

        .scroll-crumb-section,
        .scroll-crumb-subsection {
          max-width: 24rem;
          font-size: 0.98rem;
          font-weight: 600;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .scroll-crumb-subsection {
          color: var(--muted);
          font-weight: 500;
        }

        .scroll-crumb-sep {
          color: rgba(17, 17, 17, 0.28);
          font-size: 0.9rem;
          user-select: none;
        }

        .scroll-crumb-subwrap[hidden] {
          display: none;
        }

        .scroll-crumb-toggle {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          margin-left: auto;
          padding: 0.15rem 0.3rem 0.15rem 0.1rem;
          border: 0;
          background: transparent;
          color: rgba(17, 17, 17, 0.54);
          cursor: pointer;
          line-height: 1;
          transition: color 120ms ease;
        }

        .scroll-crumb-toggle:hover {
          color: rgba(17, 17, 17, 0.72);
        }

        .scroll-crumb-toggle:focus-visible {
          outline: 2px solid rgba(192, 57, 43, 0.35);
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
        }

        .scroll-crumb-menu {
          margin-top: 0.55rem;
          padding: 0.8rem 0.85rem 0.9rem;
          border: 1px solid rgba(17, 17, 17, 0.08);
          border-radius: 1rem;
          background: rgba(255, 255, 255, 0.74);
          box-shadow: 0 20px 44px rgba(17, 17, 17, 0.08);
          backdrop-filter: blur(18px) saturate(150%);
          -webkit-backdrop-filter: blur(18px) saturate(150%);
          max-height: min(68vh, calc(100vh - 5.5rem));
          overflow-y: auto;
          overscroll-behavior: contain;
          -webkit-overflow-scrolling: touch;
          scrollbar-width: thin;
          scrollbar-color: rgba(17, 17, 17, 0.18) transparent;
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
          background: rgba(17, 17, 17, 0.16);
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
          background: rgba(17, 17, 17, 0.05);
          outline: none;
        }

        .scroll-crumb-menu .contents a.is-current {
          background: rgba(17, 17, 17, 0.08);
          color: var(--accent);
          font-weight: 600;
        }

        .scroll-crumb-menu .contents a.is-current .toc-number {
          color: var(--accent);
        }

        .scroll-crumb-menu .contents a.is-current-parent {
          background: rgba(17, 17, 17, 0.04);
          color: var(--ink);
        }

        .chapter-list {
          margin: 0;
          padding: 0;
          list-style: none;
          columns: 2 18rem;
          column-gap: 2.5rem;
        }

        .chapter-list li {
          break-inside: avoid;
          margin: 0 0 1rem;
          padding: 0 0 1rem;
          border-bottom: 1px solid var(--rule);
        }

        .chapter-list a {
          text-decoration: none;
        }

        .chapter-list .chapter-no {
          display: block;
          margin-bottom: 0.22rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
        }

        .chapter-list .chapter-title {
          display: block;
          font-family: var(--font-display);
          font-size: 1.15rem;
          font-weight: 600;
          line-height: 1.18;
          letter-spacing: -0.02em;
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
          background: var(--accent-soft);
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
          font-weight: 650;
          letter-spacing: 0.015em;
        }

        .styr-tr {
          position: absolute;
          left: 50%;
          bottom: calc(100% + 0.3rem);
          transform: translateX(-50%);
          opacity: 0;
          pointer-events: none;
          z-index: 3;
          background: var(--ink);
          border-radius: 0.2rem;
          padding: 0.18rem 0.42rem 0.16rem;
          color: rgba(255, 255, 255, 0.88);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-style: normal;
          font-weight: 500;
          letter-spacing: 0.03em;
          white-space: nowrap;
          transition: opacity 120ms ease;
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
          white-space: nowrap;
        }

        .example {
          display: block;
          margin: 0.1rem 0 0.28rem;
        }

        .example-text {
          display: block;
          font-weight: 650;
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

          .chapter-list {
            columns: 1;
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
          color: rgba(255, 255, 255, 0.55);
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
            font-size: 1.04rem;
            line-height: 1.62;
          }

          .navline {
            gap: 0.55rem 1rem;
          }

          .scroll-crumb {
            top: 0.55rem;
            width: min(calc(100vw - 0.8rem), 56rem);
          }

          .scroll-crumb-inner {
            min-height: 2.7rem;
            padding: 0.35rem 0.4rem;
          }

          .scroll-crumb-item {
            padding: 0.3rem 0.55rem;
          }

          .scroll-crumb-chapter {
            display: none;
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
          display: inline-flex;
          align-items: center;
          gap: 0.45rem;
          margin-top: 1.4rem;
          padding: 0.55rem 1.1rem;
          background: transparent;
          color: var(--ink);
          border: 1px solid var(--rule);
          border-radius: 0.3rem;
          font-family: var(--font-ui);
          font-size: 0.72rem;
          font-weight: 500;
          letter-spacing: 0.07em;
          text-transform: uppercase;
          cursor: pointer;
          transition: border-color 120ms ease, color 120ms ease;
        }

        .dl-btn:hover {
          border-color: var(--ink);
          color: var(--ink);
        }

        .dl-btn:disabled {
          opacity: 0.4;
          cursor: not-allowed;
        }

        .dl-btn svg {
          width: 1em;
          height: 1em;
          fill: currentColor;
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
          border: 1px solid var(--rule);
          border-radius: 999px;
          background: rgba(255, 255, 255, 0.9);
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
          color: var(--ink);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 500;
          letter-spacing: 0.08em;
          text-transform: uppercase;
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
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
        }

        .back-to-top.is-visible {
          opacity: 1;
          visibility: visible;
          pointer-events: auto;
          transform: translateY(0);
        }

        .back-to-top:hover {
          background: rgba(255, 255, 255, 0.98);
          border-color: rgba(17, 17, 17, 0.3);
          box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }

        .back-to-top:focus-visible {
          outline: 2px solid rgba(192, 57, 43, 0.4);
          outline-offset: 3px;
        }

        .back-to-top svg {
          width: 0.95rem;
          height: 0.95rem;
          flex-shrink: 0;
          fill: none;
          stroke: currentColor;
          stroke-width: 1.7;
          stroke-linecap: round;
          stroke-linejoin: round;
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
          border-bottom: 1px dotted rgba(192, 57, 43, 0.28);
          transition: border-color 150ms ease;
        }

        .styr[data-ref]:hover {
          border-bottom-color: rgba(192, 57, 43, 0.7);
        }

        /* ── Lexicon sidebar panel ─────────────────────────────── */

        .lex-overlay {
          position: fixed;
          inset: 0;
          z-index: 90;
          background: rgba(0, 0, 0, 0);
          pointer-events: none;
          transition: background 200ms ease;
        }

        .lex-overlay-visible {
          background: rgba(0, 0, 0, 0.18);
          pointer-events: auto;
        }

        .lex-panel {
          position: fixed;
          top: 0;
          right: 0;
          bottom: 0;
          z-index: 100;
          width: min(22rem, 88vw);
          background: var(--paper);
          border-left: 1px solid var(--rule);
          box-shadow: -4px 0 24px rgba(0, 0, 0, 0.08);
          transform: translateX(100%);
          transition: transform 220ms cubic-bezier(0.4, 0, 0.2, 1);
          overflow-y: auto;
          display: flex;
          flex-direction: column;
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
          background: none;
          border: none;
          cursor: pointer;
          font-size: 1.4rem;
          line-height: 1;
          color: var(--muted);
          padding: 0.2rem 0.4rem;
          border-radius: 0.25rem;
          transition: color 120ms ease;
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
          font-weight: 650;
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
          font-weight: 650;
        }

        .lex-form-tr {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.82rem;
          letter-spacing: 0.02em;
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
          background: rgba(244, 223, 118, 0.45);
          border-radius: 0.18rem;
          box-decoration-break: clone;
          -webkit-box-decoration-break: clone;
          padding: 0 0.12rem;
        }

        .lex-locus-context .lex-locus-fade {
          color: var(--muted);
        }

        .styr.lex-highlight {
          background: rgba(192, 57, 43, 0.08);
          border-radius: 0.2rem;
          outline: 1.5px solid rgba(192, 57, 43, 0.28);
          outline-offset: 1px;
          transition: outline-color 600ms ease, background 600ms ease;
        }

        @media (max-width: 640px) {
          .lex-panel {
            width: 100vw;
          }
        }

        /* ── Selection highlight override ───────────────────────── */

        ::selection {
          background: rgba(192, 57, 43, 0.1);
          color: inherit;
        }

        ::-moz-selection {
          background: rgba(192, 57, 43, 0.1);
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
          background: var(--ink);
          border-radius: 0.35rem;
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18), 0 1px 3px rgba(0, 0, 0, 0.1);
          padding: 0.3rem;
          max-width: calc(100vw - 1rem);
          opacity: 0;
          transform: translateX(-50%) translateY(0.4rem);
          pointer-events: none;
          visibility: hidden;
          transition: opacity 120ms ease, transform 120ms ease;
          overflow: hidden;
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
          color: rgba(255, 255, 255, 0.88);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
        }

        .copy-popup-copied .copy-popup-confirm {
          display: flex;
        }

        .copy-popup-confirm svg {
          flex-shrink: 0;
        }

        .copy-popup-hint {
          display: none;
          padding: 0 0.45rem 0 0.2rem;
          color: rgba(255, 255, 255, 0.62);
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
          color: rgba(255, 234, 230, 0.95);
          background: #6f2418;
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
          background: var(--ink);
          color: rgba(255, 255, 255, 0.82);
          font-family: var(--font-ui);
          font-size: 0.68rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          white-space: nowrap;
          cursor: pointer;
          transition: background 100ms ease, color 100ms ease;
        }

        .copy-popup-btn:disabled {
          cursor: default;
          opacity: 0.45;
        }

        .copy-popup-btn:hover {
          background: #333;
          color: #fff;
        }

        .copy-popup-btn:disabled:hover {
          background: var(--ink);
          color: rgba(255, 255, 255, 0.82);
        }

        .copy-popup-btn + .copy-popup-btn {
          border-left: 1px solid rgba(255, 255, 255, 0.12);
        }

        .copy-popup-btn svg {
          flex-shrink: 0;
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
            <p class="eyebrow"><xsl:value-of select="@language"/></p>
            <h1><xsl:value-of select="@t"/></h1>
          </header>

          <main class="layout">
            <div class="main prose">
              <ol class="chapter-list">
                <xsl:apply-templates select="ch" mode="contents-card"/>
              </ol>
              <button class="dl-btn" id="dl-all" type="button">
                &#x2B73; Download full grammar
              </button>
            </div>
          </main>
        </div>
        <button class="back-to-top" id="back-to-top" type="button" aria-label="Back to top">
          <svg viewBox="0 0 16 16" aria-hidden="true">
            <path d="M8 12.5V3.5"/>
            <path d="M4.5 7 8 3.5 11.5 7"/>
          </svg>
          <span class="back-to-top-label">Back to top</span>
        </button>
        <script src="markup.js"></script>
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
            <a class="scroll-crumb-item scroll-crumb-home" href="index.xml">Contents</a>
            <span class="scroll-crumb-sep" aria-hidden="true">/</span>
            <a class="scroll-crumb-item scroll-crumb-chapter" id="scroll-crumb-chapter" href="#top"></a>
            <span class="scroll-crumb-sep" aria-hidden="true">/</span>
            <a class="scroll-crumb-item scroll-crumb-section" id="scroll-crumb-section" href="#top"></a>
            <span class="scroll-crumb-subwrap" id="scroll-crumb-subwrap" hidden="hidden">
              <span class="scroll-crumb-sep" aria-hidden="true">/</span>
              <a class="scroll-crumb-item scroll-crumb-subsection" id="scroll-crumb-subsection" href="#top"></a>
            </span>
            <button class="scroll-crumb-toggle" id="scroll-crumb-toggle" type="button" aria-expanded="false" aria-controls="scroll-crumb-menu" aria-label="Open page contents">
              <span class="scroll-crumb-toggle-icon icon-expand" aria-hidden="true">
                <i class="bi bi-chevron-down"></i>
              </span>
              <span class="scroll-crumb-toggle-icon icon-collapse" aria-hidden="true">
                <i class="bi bi-chevron-up"></i>
              </span>
            </button>
          </nav>
          <div class="scroll-crumb-menu" id="scroll-crumb-menu" hidden="hidden">
            <ol class="contents">
              <xsl:apply-templates select="sec" mode="section-toc"/>
            </ol>
          </div>
        </div>
        <button class="back-to-top" id="back-to-top" type="button" aria-label="Back to top">
          <svg viewBox="0 0 16 16" aria-hidden="true">
            <path d="M8 12.5V3.5"/>
            <path d="M4.5 7 8 3.5 11.5 7"/>
          </svg>
          <span class="back-to-top-label">Back to top</span>
        </button>
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
      <a href="{@file}">
        <span class="chapter-no">Chapter <xsl:value-of select="@id"/></span>
        <span class="chapter-title"><xsl:value-of select="@t"/></span>
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
      <xsl:attribute name="title">
        <xsl:choose>
          <xsl:when test="$show-token-tr and @tr and string-length(@tr) &gt; 0">
            <xsl:value-of select="@v"/>
            <xsl:text> [</xsl:text>
            <xsl:value-of select="@tr"/>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@v"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
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

    <xsl:choose>
      <xsl:when test="$entry/form[@f = $form-id]">
        <xsl:value-of select="$entry/form[@f = $form-id][1]/@v"/>
      </xsl:when>
      <xsl:when test="string-length($entry/@template) &gt; 0">
        <xsl:variable name="pattern" select="$lexdoc/templates/*[@id = $entry/@template]/form[@f = $form-id][1]"/>
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
    <xsl:variable name="lexdoc" select="document($lexicon-uri)/lexicon"/>
    <xsl:variable name="entry" select="$lexdoc/lex[@id = $ref]"/>

    <xsl:choose>

      <!-- ── Pre-resolved by download.js (@v set in JS before transform) ──
           Browsers block document() inside XSLTProcessor, so the download
           button pre-resolves <w> elements by setting @v (display form) and
           @lemma before calling transformToDocument().  This branch handles
           those elements and produces identical output to the found-entry
           branch without needing document().
      ──────────────────────────────────────────────────────────────── -->
      <xsl:when test="string-length(@v) &gt; 0">
        <xsl:variable name="pre-fv" select="string(@v)"/>
        <xsl:variable name="pre-lemma">
          <xsl:choose>
            <xsl:when test="string-length(@lemma) &gt; 0"><xsl:value-of select="@lemma"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@v"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="styr">
          <xsl:attribute name="data-cyr"><xsl:value-of select="$pre-fv"/></xsl:attribute>
          <xsl:attribute name="data-lemma"><xsl:value-of select="$pre-lemma"/></xsl:attribute>
          <xsl:if test="string-length($infl) &gt; 0">
            <xsl:attribute name="data-infl"><xsl:value-of select="$infl"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="title">
            <xsl:value-of select="$pre-fv"/>
            <xsl:if test="string-length($infl) &gt; 0">
              <xsl:text> · </xsl:text>
              <xsl:value-of select="$infl"/>
              <xsl:text> of </xsl:text>
              <xsl:value-of select="$pre-lemma"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:attribute name="data-ref"><xsl:value-of select="$ref"/></xsl:attribute>
          <span class="styr-form"><xsl:value-of select="$pre-fv"/></span>
          <span class="styr-tr">
            <span class="styr-tr-text"/>
            <xsl:if test="string-length($infl) &gt; 0">
              <span class="styr-infl-tag">
                <xsl:value-of select="$infl"/>
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
          <xsl:if test="string-length($infl) &gt; 0">
            <xsl:call-template name="resolve-lex-form">
              <xsl:with-param name="entry" select="$entry"/>
              <xsl:with-param name="form-id" select="$infl"/>
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
        <xsl:variable name="show-token-tr" select="true()"/>

        <!-- @cap="1": capitalise the first letter of the rendered form
             and its transliteration (sentence-initial position).           -->
        <xsl:variable name="display-v">
          <xsl:choose>
            <xsl:when test="@cap = '1'">
              <xsl:value-of select="concat(
                translate(substring($fv, 1, 1),
                  'абвгдежзийіклмнопрстуфхцчшъюя',
                  'АБВГДЕЖЗИЙІКЛМНОПРСТУФХЦЧШЪЮЯ'),
                substring($fv, 2))"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$fv"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <span class="styr">
          <xsl:attribute name="data-cyr"><xsl:value-of select="$display-v"/></xsl:attribute>
          <xsl:attribute name="data-lemma"><xsl:value-of select="$lemma-v"/></xsl:attribute>
          <xsl:if test="string-length($infl) &gt; 0">
            <xsl:attribute name="data-infl"><xsl:value-of select="$infl"/></xsl:attribute>
          </xsl:if>
          <!-- title tooltip: "Писа [Pysa] · 3sg of писат" -->
          <xsl:attribute name="title">
            <xsl:value-of select="$display-v"/>
            <xsl:if test="string-length($infl) &gt; 0">
              <xsl:text> · </xsl:text>
              <xsl:value-of select="$infl"/>
              <xsl:text> of </xsl:text>
              <xsl:value-of select="$lemma-v"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="$show-token-tr">
            <xsl:attribute name="data-ref"><xsl:value-of select="$ref"/></xsl:attribute>
          </xsl:if>

          <span class="styr-form"><xsl:value-of select="$display-v"/></span>

          <!-- Hover bubble: transliteration + optional infl badge -->
          <xsl:if test="$show-token-tr">
            <span class="styr-tr">
              <span class="styr-tr-text"/>
              <!-- Infl badge: only when an explicit @infl was requested -->
              <xsl:if test="string-length($infl) &gt; 0">
                <span class="styr-infl-tag">
                  <xsl:value-of select="$infl"/>
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
          <xsl:attribute name="title">
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
