function n(t){return!t||typeof t!="string"?"":!t.startsWith("http")||t.includes("/file/proxy")?t:`${"http://localhost:8080".replace(/\/$/,"")}/file/proxy?url=${encodeURIComponent(t)}`}export{n as g};
