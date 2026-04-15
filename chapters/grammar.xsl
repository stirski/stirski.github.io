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
      <style type="text/css"><![CDATA[
        :root {
          --paper: #fcfbf7;
          --ink: #141414;
          --muted: #5f5954;
          --rule: #d7d0c8;
          --accent: #181716;
          --accent-soft: #f1ece4;
          --signal: #d84a2f;
          --font-body: "Inter", "Inter Variable", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-display: "Inter", "Inter Variable", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-ui: "Inter", "Inter Variable", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          --font-mono: "SFMono-Regular", "Cascadia Mono", Consolas, monospace;
          --measure: 38rem;
          --margin-col: 16rem;
        }


        html {
          scroll-behavior: smooth;
        }

        body {
          margin: 0;
          background: var(--paper);
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
          text-decoration-color: rgba(216, 74, 47, 0.35);
          text-underline-offset: 0.14em;
        }

        a:hover {
          text-decoration-color: rgba(216, 74, 47, 0.78);
        }

        .page {
          width: min(92vw, 76rem);
          margin: 0 auto;
          padding: 2.25rem 0 4rem;
        }

        .masthead {
          padding: 0 0 1.4rem;
          border-bottom: 1px solid var(--rule);
          margin-bottom: 2rem;
        }

        .eyebrow {
          margin: 0 0 0.45rem;
          color: var(--muted);
          font-family: var(--font-display);
          font-size: 0.74rem;
          font-weight: 800;
          letter-spacing: 0.18em;
          text-transform: uppercase;
        }

        h1,
        h2,
        h3 {
          margin: 0;
          font-family: var(--font-display);
          font-weight: 800;
          line-height: 0.98;
          color: var(--accent);
          text-wrap: balance;
        }

        h1 {
          max-width: 13ch;
          font-size: clamp(2.2rem, 4.8vw, 3.9rem);
          letter-spacing: -0.07em;
          text-transform: uppercase;
        }

        .deck {
          max-width: 30rem;
          margin: 0.85rem 0 0;
          color: var(--muted);
          font-size: 1.05rem;
          line-height: 1.56;
        }

        .navline {
          display: flex;
          flex-wrap: wrap;
          gap: 0.9rem 1.35rem;
          margin-top: 1rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.8rem;
          font-weight: 700;
          letter-spacing: 0.08em;
          text-transform: uppercase;
        }

        .layout {
          display: grid;
          grid-template-columns: minmax(0, var(--measure)) minmax(12rem, var(--margin-col));
          gap: 2.75rem;
          align-items: start;
        }

        .main {
          min-width: 0;
        }

        .aside {
          min-width: 0;
        }

        .meta {
          margin: 0 0 1.6rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.82rem;
          line-height: 1.55;
        }

        .prose {
          hanging-punctuation: first last;
          hyphens: auto;
          font-size: 1.02rem;
          line-height: 1.68;
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

        .prose h2 {
          max-width: var(--measure);
          margin: 0 0 0.9rem;
          padding-top: 1.15rem;
          border-top: 1px solid var(--rule);
          font-size: clamp(1.42rem, 2.2vw, 1.85rem);
          font-weight: 760;
          letter-spacing: -0.02em;
        }

        .prose h3 {
          max-width: var(--measure);
          margin: 0 0 0.72rem;
          font-size: clamp(1.22rem, 2.2vw, 1.62rem);
          letter-spacing: -0.03em;
        }

        .section-number {
          display: inline-block;
          margin-right: 0.62rem;
          color: var(--signal);
          font-family: var(--font-display);
          font-size: 0.7em;
          font-weight: 800;
          letter-spacing: 0.16em;
        }

        .contents {
          margin: 0;
          padding: 0;
          list-style: none;
          border-left: 1px solid var(--rule);
          padding-left: 1rem;
          font-size: 0.92rem;
          line-height: 1.5;
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
          margin: 0.35rem 0 0.2rem 0.8rem;
          padding: 0 0 0 0.8rem;
          list-style: none;
          border-left: 1px solid var(--rule);
        }

        .contents .toc-number {
          display: inline-block;
          min-width: 2.5em;
          color: var(--signal);
          font-family: var(--font-display);
          font-size: 0.78em;
          font-weight: 800;
          letter-spacing: 0.08em;
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
          color: var(--signal);
          font-family: var(--font-display);
          font-size: 0.74rem;
          font-weight: 800;
          letter-spacing: 0.14em;
          text-transform: uppercase;
        }

        .chapter-list .chapter-title {
          display: block;
          font-family: var(--font-display);
          font-size: 1.2rem;
          font-weight: 750;
          line-height: 1.14;
          letter-spacing: -0.03em;
          text-transform: uppercase;
        }

        .chapter-list .chapter-file {
          display: block;
          margin-top: 0.22rem;
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.74rem;
          letter-spacing: 0.05em;
          text-transform: uppercase;
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
          font-size: 0.74rem;
          font-weight: 800;
          letter-spacing: 0.12em;
          text-transform: uppercase;
        }

        td,
        th {
          padding: 0.5rem 0.6rem 0.55rem 0;
          border-bottom: 1px solid #ece6de;
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

        .aside-note {
          color: var(--muted);
          font-size: 0.88rem;
          line-height: 1.55;
        }

        @media (max-width: 980px) {
          .layout {
            grid-template-columns: minmax(0, 1fr);
            gap: 1.75rem;
          }

          .aside {
            order: -1;
          }

          .chapter-list {
            columns: 1;
          }

          .contents {
            padding-left: 0;
            border-left: 0;
            border-top: 1px solid var(--rule);
            padding-top: 1rem;
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
            width: min(94vw, 76rem);
            padding-top: 1.3rem;
          }

          .prose {
            font-size: 1.06rem;
            line-height: 1.66;
          }

          .navline {
            gap: 0.55rem 1rem;
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
          background: var(--accent);
          color: var(--paper);
          border: none;
          border-radius: 0.35rem;
          font-family: var(--font-ui);
          font-size: 0.78rem;
          font-weight: 700;
          letter-spacing: 0.1em;
          text-transform: uppercase;
          cursor: pointer;
          transition: background 120ms ease;
        }

        .dl-btn:hover {
          background: var(--signal);
        }

        .dl-btn:disabled {
          opacity: 0.5;
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
          padding: 0.72rem 0.95rem;
          border: 1px solid rgba(20, 20, 20, 0.14);
          border-radius: 999px;
          background: rgba(252, 251, 247, 0.92);
          box-shadow: 0 12px 28px rgba(20, 20, 20, 0.12);
          color: var(--accent);
          font-family: var(--font-ui);
          font-size: 0.72rem;
          font-weight: 800;
          letter-spacing: 0.12em;
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
          background: rgba(252, 251, 247, 0.98);
          border-color: rgba(216, 74, 47, 0.28);
          box-shadow: 0 16px 34px rgba(20, 20, 20, 0.16);
        }

        .back-to-top:focus-visible {
          outline: 2px solid rgba(216, 74, 47, 0.42);
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
          border-bottom: 1px dotted rgba(216, 74, 47, 0.35);
          transition: border-color 150ms ease;
        }

        .styr[data-ref]:hover {
          border-bottom-color: rgba(216, 74, 47, 0.78);
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
          font-size: 1.6rem;
          font-weight: 760;
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
          color: var(--signal);
          font-family: var(--font-ui);
          font-size: 0.72rem;
          font-weight: 800;
          letter-spacing: 0.12em;
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
          border-bottom: 1px solid #ece6de;
          vertical-align: top;
        }

        .lex-forms tbody tr:last-child td {
          border-bottom: 0;
        }

        .lex-form-label {
          color: var(--muted);
          font-family: var(--font-ui);
          font-size: 0.72rem;
          font-weight: 700;
          letter-spacing: 0.06em;
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
          font-size: 0.72rem;
          font-weight: 800;
          letter-spacing: 0.12em;
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
          font-size: 0.72rem;
          font-weight: 800;
          letter-spacing: 0.12em;
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
          font-weight: 700;
          color: var(--signal);
        }

        .lex-locus-context .lex-locus-fade {
          color: var(--muted);
        }

        .styr.lex-highlight {
          background: rgba(216, 74, 47, 0.12);
          border-radius: 0.2rem;
          outline: 2px solid rgba(216, 74, 47, 0.35);
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
          background: rgba(216, 74, 47, 0.14);
          color: inherit;
        }

        ::-moz-selection {
          background: rgba(216, 74, 47, 0.14);
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
        <div class="page">
          <header class="masthead">
            <p class="eyebrow"><xsl:value-of select="@language"/></p>
            <h1><xsl:value-of select="@t"/></h1>
          </header>

          <main class="layout">
            <div class="main prose">
              <p class="meta">Serve this directory locally and open the XML files directly; each document resolves through the shared XSL stylesheet.</p>
              <ol class="chapter-list">
                <xsl:apply-templates select="ch" mode="contents-card"/>
              </ol>
              <button class="dl-btn" id="dl-all" type="button">
                &#x2B73; Download full grammar
              </button>
            </div>
            <aside class="aside aside-note">
              <p>Each chapter can be opened as XML and rendered in place.</p>
              <p>The `st` element carries the displayed form in `@v` and optional explicit transliteration in `@tr`; lexicon-backed `w` forms derive theirs from the shared mapping file.</p>
            </aside>
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
        <div class="page">
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

          <main class="layout">
            <article class="main prose">
              <p class="meta">Hover any Styrian form to reveal its transliteration. Lexicon-backed forms are generated from the shared Cyrillic mapping.</p>
              <xsl:apply-templates select="node()"/>
            </article>

            <aside class="aside">
              <xsl:if test="sec">
                <ol class="contents">
                  <xsl:apply-templates select="sec" mode="section-toc"/>
                </ol>
              </xsl:if>
            </aside>
          </main>
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
        <span class="chapter-file"><xsl:value-of select="@file"/></span>
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
      <h2>
        <span class="section-number"><xsl:number level="single" count="sec"/></span>
        <xsl:value-of select="@t"/>
      </h2>
      <xsl:apply-templates select="node()"/>
    </section>
  </xsl:template>

  <xsl:template match="sub">
    <div class="subsection" id="subsec-{count(preceding::sub) + 1}">
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
