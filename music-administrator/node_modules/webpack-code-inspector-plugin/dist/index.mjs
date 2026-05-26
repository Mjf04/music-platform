var _ = Object.defineProperty, C = Object.defineProperties;
var W = Object.getOwnPropertyDescriptors;
var b = Object.getOwnPropertySymbols;
var $ = Object.prototype.hasOwnProperty, w = Object.prototype.propertyIsEnumerable;
var A = (t, e, s) => e in t ? _(t, e, { enumerable: !0, configurable: !0, writable: !0, value: s }) : t[e] = s, d = (t, e) => {
  for (var s in e || (e = {}))
    $.call(e, s) && A(t, s, e[s]);
  if (b)
    for (var s of b(e))
      w.call(e, s) && A(t, s, e[s]);
  return t;
}, y = (t, e) => C(t, W(e));
var i = (t, e, s) => new Promise((n, o) => {
  var a = (r) => {
    try {
      f(s.next(r));
    } catch (c) {
      o(c);
    }
  }, u = (r) => {
    try {
      f(s.throw(r));
    } catch (c) {
      o(c);
    }
  }, f = (r) => r.done ? n(r.value) : Promise.resolve(r.value).then(a, u);
  f((s = s.apply(t, e)).next());
});
import { normalizePath as g, fileURLToPath as D, isDev as E, getCodeWithWebComponent as T } from "code-inspector-core";
import h, { dirname as L } from "path";
function O(t, e) {
  return i(this, null, function* () {
    if (!t || !e)
      return [];
    const s = typeof t == "function" ? yield t() : t;
    let n = [];
    if (typeof s == "object" && !Array.isArray(s))
      for (const o in s) {
        const a = s[o], u = a.import || a;
        k(n, u, e);
      }
    else
      k(n, s, e);
    return n.filter((o) => !!o);
  });
}
function k(t, e, s) {
  typeof e == "string" ? t.push(p(e, s)) : Array.isArray(e) && t.push(
    ...e.map((n) => p(n, s))
  );
}
function p(t, e) {
  return h.isAbsolute(t) ? g(t) : t.startsWith(".") ? h.resolve(e, g(t)) : "";
}
let l = "";
typeof __dirname != "undefined" ? l = __dirname : l = L(D(import.meta.url));
let v = !0;
const z = (t, e) => {
  var u, f;
  if (!v)
    return;
  v = !1;
  const s = (e == null ? void 0 : e.compiler) || e, n = (u = s == null ? void 0 : s.options) == null ? void 0 : u.module, o = (n == null ? void 0 : n.rules) || (n == null ? void 0 : n.loaders) || [];
  let a = t.include || [];
  Array.isArray(a) || (a = [a]), o.push(
    d({
      test: (f = t == null ? void 0 : t.match) != null ? f : /\.(vue|jsx|tsx|js|ts|mjs|mts)$/,
      exclude: /node_modules/,
      use: [
        {
          loader: h.resolve(l, "./loader.js"),
          options: t
        }
      ]
    }, t.enforcePre === !1 ? {} : { enforce: "pre" }),
    ...a.map((r) => d({
      resource: {
        and: [r, /\.(vue|jsx|tsx|js|ts|mjs|mts)$/]
      },
      use: [
        {
          loader: h.resolve(l, "./loader.js"),
          options: t
        }
      ]
    }, t.enforcePre === !1 ? {} : { enforce: "pre" })),
    y(d({}, t != null && t.injectTo ? { resource: t == null ? void 0 : t.injectTo } : {
      test: /\.(jsx|tsx|js|ts|mjs|mts)$/,
      exclude: /node_modules/
    }), {
      use: [
        {
          loader: h.resolve(l, "./inject-loader.js"),
          options: t
        }
      ],
      enforce: "post"
    })
  );
};
function I(n) {
  return i(this, arguments, function* ({
    options: t,
    record: e,
    assets: s
  }) {
    const o = Object.keys(s).filter((a) => /\.html$/.test(a));
    if (o.length) {
      const a = yield T({
        options: y(d({}, t), { importClient: "code" }),
        file: "main.js",
        code: "",
        record: e,
        inject: !0
      });
      o.forEach((u) => {
        var r, c;
        const f = (c = (r = s[u]) == null ? void 0 : r.source) == null ? void 0 : c.call(r);
        if (typeof f == "string") {
          const j = f.replace(
            "<head>",
            '<head><script type="module">\n'.concat(a, "\n<\/script>")
          );
          s[u] = {
            source: () => j,
            size: () => j.length
          };
        }
      });
    }
  });
}
class H {
  constructor(e) {
    this.options = e;
  }
  apply(e) {
    return i(this, null, function* () {
      var n, o, a, u, f, r;
      if (v = !0, this.options.close || !E(
        this.options.dev,
        ((n = e == null ? void 0 : e.options) == null ? void 0 : n.mode) === "development" || process.env.NODE_ENV === "development"
      ))
        return;
      ((a = (o = e == null ? void 0 : e.options) == null ? void 0 : o.cache) == null ? void 0 : a.type) === "filesystem" && (e.options.cache.version = "code-inspector-".concat(Date.now()));
      const s = {
        port: 0,
        entry: "",
        output: this.options.output,
        inputs: O(
          (u = e == null ? void 0 : e.options) == null ? void 0 : u.entry,
          (f = e == null ? void 0 : e.options) == null ? void 0 : f.context
        )
      };
      if (z(y(d({}, this.options), { record: s }), e), (r = e == null ? void 0 : e.hooks) != null && r.emit) {
        const c = this.options;
        e.hooks.emit.tapAsync(
          "WebpackCodeInspectorPlugin",
          (j, x) => i(this, null, function* () {
            const { assets: P = {} } = j;
            yield I({
              options: c,
              record: s,
              assets: P
            }), x();
          })
        );
      }
    });
  }
}
export {
  H as default
};
