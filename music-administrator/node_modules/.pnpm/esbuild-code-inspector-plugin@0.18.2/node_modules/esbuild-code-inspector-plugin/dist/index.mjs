var m = (s, c, i) => new Promise((l, a) => {
  var p = (t) => {
    try {
      o(i.next(t));
    } catch (n) {
      a(n);
    }
  }, e = (t) => {
    try {
      o(i.throw(t));
    } catch (n) {
      a(n);
    }
  }, o = (t) => t.done ? l(t.value) : Promise.resolve(t.value).then(p, e);
  o((i = i.apply(s, c)).next());
});
import { isDev as h, getMappingFilePath as C, matchCondition as v, getCodeWithWebComponent as x, isJsTypeFile as j, transformCode as d, parseSFC as y } from "code-inspector-core";
import F from "fs";
import P from "path";
const W = "esbuild-code-inspector-plugin";
function D(s) {
  return {
    name: W,
    setup(c) {
      if (s.close || !h(s.dev, !1))
        return;
      const i = {
        port: 0,
        entry: "",
        output: s.output
      }, { escapeTags: l = [] } = s, a = /* @__PURE__ */ new Map();
      c.onLoad(
        { filter: s.match || /\.(jsx|tsx|js|ts|mjs|mts)?$/ },
        (p) => m(this, null, function* () {
          let e = p.path;
          e = C(e, s.mappings);
          let o = yield F.promises.readFile(e, "utf8"), t = a.get(e);
          if (!t || t.originCode !== o) {
            let n = o;
            if (e.match("node_modules")) {
              if (!v(s.include || [], e))
                return n;
            } else
              n = yield x({
                options: s,
                file: e,
                code: n,
                record: i
              });
            let r = "";
            if (j(e) ? r = "jsx" : e.endsWith(".svelte") && (r = "svelte"), r)
              n = d({
                content: n,
                filePath: e,
                fileType: r,
                escapeTags: l
              });
            else if (e.endsWith(".vue")) {
              r = "vue";
              const { descriptor: u } = y(n, {
                sourceMap: !1
              }), g = d({
                content: u.template.content,
                filePath: e,
                fileType: r,
                escapeTags: l
              });
              n = n.replace(u.template.content, g);
            }
            const f = P.extname(e).replace(".", "");
            t = { originCode: o, output: { contents: n, loader: f } }, a.set(e, t);
          }
          return t.output;
        })
      );
    }
  };
}
export {
  D as EsbuildCodeInspectorPlugin
};
