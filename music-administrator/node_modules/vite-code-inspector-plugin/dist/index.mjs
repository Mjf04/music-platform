var y = Object.defineProperty, P = Object.defineProperties;
var j = Object.getOwnPropertyDescriptors;
var p = Object.getOwnPropertySymbols;
var C = Object.prototype.hasOwnProperty, o = Object.prototype.propertyIsEnumerable;
var d = (e, t, a) => t in e ? y(e, t, { enumerable: !0, configurable: !0, writable: !0, value: a }) : e[t] = a, f = (e, t) => {
  for (var a in t || (t = {}))
    C.call(t, a) && d(e, a, t[a]);
  if (p)
    for (var a of p(t))
      o.call(t, a) && d(e, a, t[a]);
  return e;
}, g = (e, t) => P(e, j(t));
var h = (e, t, a) => new Promise((l, n) => {
  var m = (r) => {
    try {
      c(a.next(r));
    } catch (s) {
      n(s);
    }
  }, u = (r) => {
    try {
      c(a.throw(r));
    } catch (s) {
      n(s);
    }
  }, c = (r) => r.done ? l(r.value) : Promise.resolve(r.value).then(m, u);
  c((a = a.apply(e, t)).next());
});
import { isDev as W, matchCondition as w, getCodeWithWebComponent as x, normalizePath as T, getMappingFilePath as _, isJsTypeFile as F, transformCode as I } from "code-inspector-core";
const J = "vite-code-inspector-plugin", L = ["isJsx", "isTsx", "lang.jsx", "lang.tsx"];
function D(e) {
  const t = {
    port: 0,
    entry: "",
    output: e.output
  };
  return g(f({
    name: J
  }, e.enforcePre === !1 ? {} : { enforce: "pre" }), {
    apply(l, { command: n }) {
      return !(e != null && e.close) && W(e.dev, n === "serve");
    },
    transform(l, n) {
      return h(this, null, function* () {
        if (n.match("node_modules")) {
          if (!w(e.include || [], n))
            return l;
        } else
          l = yield x({
            options: e,
            file: n,
            code: l,
            record: t
          });
        const { escapeTags: m = [], mappings: u } = e || {}, [c] = n.split("?", 2);
        let r = T(c);
        r = _(r, u);
        const s = new URLSearchParams(n);
        if (e != null && e.match && !e.match.test(r))
          return l;
        let i = "";
        return F(r) || r.endsWith(".vue") && (L.some((v) => s.get(v) !== null) || s.get("lang") === "tsx" || s.get("lang") === "jsx") ? i = "jsx" : r.endsWith(".vue") && s.get("type") !== "style" && s.get("raw") === null ? i = "vue" : r.endsWith(".svelte") && (i = "svelte"), i ? I({
          content: l,
          filePath: r,
          fileType: i,
          escapeTags: m
        }) : l;
      });
    },
    // 追加到 html 中，适配 MPA 项目
    transformIndexHtml(l) {
      return h(this, null, function* () {
        const n = yield x({
          options: g(f({}, e), { importClient: "code" }),
          file: "main.js",
          code: "",
          record: t,
          inject: !0
        });
        return l.replace(
          "<head>",
          '<head><script type="module">\n'.concat(n, "\n<\/script>")
        );
      });
    }
  });
}
export {
  D as ViteCodeInspectorPlugin
};
