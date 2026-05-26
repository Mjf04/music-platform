/**
 * 将 MinIO 图片 URL 转为后端代理地址，避免跨域导致管理端无法显示
 */
export function getImageUrl(url: string | null | undefined): string {
  if (!url || typeof url !== "string") return "";

  if (!url.startsWith("http")) return url;
  if (url.includes("/file/proxy")) return url;

  const base = (
    import.meta.env.VITE_APP_BASE_API || "http://localhost:8080"
  ).replace(/\/$/, "");

  return `${base}/file/proxy?url=${encodeURIComponent(url)}`;
}
