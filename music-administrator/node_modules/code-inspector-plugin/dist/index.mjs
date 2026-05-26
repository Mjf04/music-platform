var b = Object.defineProperty, I = Object.defineProperties;
var T = Object.getOwnPropertyDescriptors;
var m = Object.getOwnPropertySymbols;
var x = Object.prototype.hasOwnProperty, _ = Object.prototype.propertyIsEnumerable;
var h = (e, t, n) => t in e ? b(e, t, { enumerable: !0, configurable: !0, writable: !0, value: n }) : e[t] = n, v = (e, t) => {
  for (var n in t || (t = {}))
    x.call(t, n) && h(e, n, t[n]);
  if (m)
    for (var n of m(t))
      _.call(t, n) && h(e, n, t[n]);
  return e;
}, g = (e, t) => I(e, T(t));
import { ViteCodeInspectorPlugin as w } from "vite-code-inspector-plugin";
import F from "webpack-code-inspector-plugin";
import { isDev as W, getMappingFilePath as D, matchCondition as E, getCodeWithWebComponent as S, isJsTypeFile as j, parseSFC as k, transformCode as C, fileURLToPath as O } from "code-inspector-core";
import u from "fs";
import d, { dirname as M } from "path";
import R from "chalk";
import L from "dotenv";
var N = (e, t, n) => new Promise((i, c) => {
  var a = (o) => {
    try {
      l(n.next(o));
    } catch (s) {
      c(s);
    }
  }, r = (o) => {
    try {
      l(n.throw(o));
    } catch (s) {
      c(s);
    }
  }, l = (o) => o.done ? i(o.value) : Promise.resolve(o.value).then(a, r);
  l((n = n.apply(e, t)).next());
});
const J = "esbuild-code-inspector-plugin";
function U(e) {
  return {
    name: J,
    setup(t) {
      if (e.close || !W(e.dev, !1))
        return;
      const n = {
        port: 0,
        entry: "",
        output: e.output
      }, { escapeTags: i = [] } = e, c = /* @__PURE__ */ new Map();
      t.onLoad(
        { filter: e.match || /\.(jsx|tsx|js|ts|mjs|mts)?$/ },
        (a) => N(this, null, function* () {
          let r = a.path;
          r = D(r, e.mappings);
          let l = yield u.promises.readFile(r, "utf8"), o = c.get(r);
          if (!o || o.originCode !== l) {
            let s = l;
            if (r.match("node_modules")) {
              if (!E(e.include || [], r))
                return s;
            } else
              s = yield S({
                options: e,
                file: r,
                code: s,
                record: n
              });
            let p = "";
            if (j(r) ? p = "jsx" : r.endsWith(".svelte") && (p = "svelte"), p)
              s = C({
                content: s,
                filePath: r,
                fileType: p,
                escapeTags: i
              });
            else if (r.endsWith(".vue")) {
              p = "vue";
              const { descriptor: f } = k(s, {
                sourceMap: !1
              }), y = C({
                content: f.template.content,
                filePath: r,
                fileType: p,
                escapeTags: i
              });
              s = s.replace(f.template.content, y);
            }
            const P = d.extname(r).replace(".", "");
            o = { originCode: l, output: { contents: s, loader: P } }, c.set(r, o);
          }
          return o.output;
        })
      );
    }
  };
}
function V(e) {
  if (!(e != null && e.bundler)) {
    console.log(
      R.red(
        "Please specify the bundler in the options of code-inspector-plugin."
      )
    );
    return;
  }
  let t = !1;
  if (e.needEnvInspector)
    if (t = !0, process.env.CODE_INSPECTOR === "true")
      t = !1;
    else {
      const a = d.resolve(process.cwd(), ".env.local");
      if (u.existsSync(a)) {
        const r = u.readFileSync(a, "utf-8"), l = L.parse(r || "");
        (l == null ? void 0 : l.CODE_INSPECTOR) === "true" && (t = !1);
      }
    }
  let n = "";
  typeof __dirname != "undefined" ? n = __dirname : n = M(O(import.meta.url));
  const i = g(v({}, e), {
    close: t,
    output: d.resolve(n, "./")
  });
  return e.bundler === "webpack" || e.bundler === "rspack" ? new F(i) : e.bundler === "esbuild" ? U(i) : w(i);
}
const Q = V;
export {
  V as CodeInspectorPlugin,
  Q as codeInspectorPlugin
};
