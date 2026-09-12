/* The grapheme lens: color as a computed observation on names.
 *
 * Default engine (config-agnostic): each grapheme carries a fixed hue
 * (golden-angle spacing over the alphabet, stable forever); a token's hue
 * is the circular mean of its graphemes' hues with exponentially decaying
 * weights, so the head morpheme dominates — tokens sharing a prefix/root
 * cohere in color automatically, and diverge gently as they diverge.
 *
 * A user configuration overrides any layer:
 *   { "words":   { "fibre": "#d9a441" },
 *     "prefixes":{ "syn": "#ffd700", "sym": "#ffd700" },
 *     "graphemes": { "s": "#e8c547" },
 *     "decay": 0.55 }
 * Longest match wins: word > longest prefix > per-grapheme blend.
 * The lens never claims semantics it wasn't given: it is a lens on
 * SPELLING, and shared spelling is the relation it surfaces.
 */
export const Grapheme = {
  cfg: { words: {}, prefixes: {}, graphemes: {}, decay: 0.55 },
  enabled: true,

  load() {
    try {
      const raw = localStorage.getItem("grapheme-config");
      if (raw) this.cfg = { ...this.cfg, ...JSON.parse(raw) };
      const en = localStorage.getItem("grapheme-enabled");
      if (en !== null) this.enabled = en === "1";
    } catch (e) { /* storage unavailable: defaults stand */ }
  },
  save(cfgText) {
    const parsed = JSON.parse(cfgText); // throws on bad input, caller shows it
    this.cfg = { ...this.cfg, ...parsed };
    try { localStorage.setItem("grapheme-config", JSON.stringify(this.cfg)); } catch (e) {}
    this._cache.clear();
  },
  toggle() {
    this.enabled = !this.enabled;
    try { localStorage.setItem("grapheme-enabled", this.enabled ? "1" : "0"); } catch (e) {}
  },

  _cache: new Map(),

  baseHue(ch) {
    const own = this.cfg.graphemes[ch];
    if (own) return hexToHue(own);
    const cp = ch.codePointAt(0);
    // golden-angle walk from the codepoint: stable, spread, alphabet-agnostic
    return (cp * 137.508) % 360;
  },

  hueOf(tokenRaw) {
    const token = tokenRaw.normalize("NFC").toLowerCase();
    if (this._cache.has(token)) return this._cache.get(token);
    let result = null;
    if (this.cfg.words[token]) result = hexToHue(this.cfg.words[token]);
    if (result === null) {
      let best = "";
      for (const p of Object.keys(this.cfg.prefixes)) {
        if (token.startsWith(p) && p.length > best.length) best = p;
      }
      if (best) result = hexToHue(this.cfg.prefixes[best]);
    }
    if (result === null) {
      // weighted circular mean, front-loaded
      const decay = this.cfg.decay;
      let x = 0, y = 0, w = 1;
      for (const ch of token) {
        if (!/[a-zऀ-ॿ0-9]/.test(ch)) continue;
        const h = this.baseHue(ch) * Math.PI / 180;
        x += Math.cos(h) * w; y += Math.sin(h) * w;
        w *= decay;
        if (w < 0.02) break;
      }
      result = ((Math.atan2(y, x) * 180 / Math.PI) + 360) % 360;
    }
    this._cache.set(token, result);
    return result;
  },

  /** CSS color for a token, tuned per theme for legibility. */
  color(token, { dark = false, strength = 1 } = {}) {
    const h = this.hueOf(token);
    const s = 55 * strength + 15;
    const l = dark ? 62 + 8 * (1 - strength) : 38 - 6 * (1 - strength);
    return `hsl(${h.toFixed(1)} ${s.toFixed(0)}% ${l}%)`;
  },

  /** Apply to an element: tinted text + hue-bearing underline. */
  paint(elm, token, dark) {
    if (!this.enabled) return;
    const c = this.color(token, { dark });
    elm.style.color = c;
    elm.style.textDecorationColor = c;
  },
};

function hexToHue(hex) {
  const m = /^#?([0-9a-f]{6})$/i.exec(hex.trim());
  if (!m) return 0;
  const v = parseInt(m[1], 16);
  const r = ((v >> 16) & 255) / 255, g = ((v >> 8) & 255) / 255, b = (v & 255) / 255;
  const mx = Math.max(r, g, b), mn = Math.min(r, g, b), d = mx - mn;
  if (!d) return 0;
  let h;
  if (mx === r) h = ((g - b) / d) % 6;
  else if (mx === g) h = (b - r) / d + 2;
  else h = (r - g) / d + 4;
  return (h * 60 + 360) % 360;
}
