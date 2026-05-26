/**
 * 这个文件 = 歌词解析工具
 * 把 LRC 歌词变成可滚动的歌词数组，并找到当前播放对应的行
 * 解析 LRC 格式歌词
 */
import type { LyricLine, ParsedLyrics } from '@/api/interface'

/**
 * 解析 LRC 格式的歌词文本为结构化数据
 * 
 * @param lyricText - 原始的 LRC 歌词字符串
 * @returns 包含解析后歌词行数组及是否包含翻译信息的对象
 */
export function parseLrc(lyricText: string): ParsedLyrics {
  console.log('=== parseLrc 开始 ===')
  console.log('输入的歌词长度:', lyricText?.length)
  console.log('歌词预览:', lyricText?.substring(0, 100))

  const lines: LyricLine[] = []
  const hasTranslation =
      lyricText.includes('[翻译:') || lyricText.includes('[译:')

  if (!lyricText) {
    return { lines: [], hasTranslation: false }
  }

  // 使用全局正则表达式匹配每一行歌词（时间戳 + 文本）
  const lineReg = /\[([\d:]+\.?\d*)](.*)/g
  let match: RegExpExecArray | null
  let matchCount = 0

  while ((match = lineReg.exec(lyricText)) !== null) {
    matchCount++
    const time = match[1]
    const text = match[2].trim()

    if (!text) continue

    // 将时间标签 [mm:ss.xx] 转换为毫秒数
    const timeParts = time.split(':')
    const minutes = parseInt(timeParts[0])
    const seconds = parseFloat(timeParts[1])
    const totalTime = (minutes * 60 + seconds) * 1000

    // 过滤掉时间和文本完全重复的歌词行
    const isDuplicate = lines.some(
        (line) =>
            line.time === totalTime && line.text === text.replace(/^\s+|\s+$/g, '')
    )

    if (!isDuplicate) {
      lines.push({
        time: totalTime,
        text: text.replace(/^\s+|\s+$/, ''),
      })
    }
  }

  console.log('匹配到的行数:', matchCount)
  console.log('返回的行数:', lines.length)
  
  // 按时间先后顺序对歌词行进行排序
  lines.sort((a, b) => a.time - b.time)

  console.log('=== parseLrc 结束 ===')
  return { lines, hasTranslation }
}

/**
 * 根据当前播放时间查找对应的歌词行索引
 * 
 * @param lines - 已解析并排序好的歌词行数组
 * @param currentTime - 当前音频播放进度（毫秒）
 * @returns 当前应高亮显示的歌词行在数组中的索引
 */
export function findLyricIndex(
    lines: LyricLine[],
    currentTime: number
): number {
  for (let i = 0; i < lines.length; i++) {
    if (currentTime < lines[i].time) {
      return Math.max(0, i - 1)
    }
  }
  return lines.length - 1
}
