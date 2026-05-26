/**
 * 音乐播放模式类型
 * 
 * - loop: 列表循环，播放完最后一首后回到第一首
 * - order: 顺序播放，按列表顺序依次播放
 * - shuffle: 随机播放，打乱歌曲顺序随机播放
 * - single: 单曲循环，重复播放当前歌曲
 */
export type PlayMode = 'loop' | 'order' | 'shuffle' | 'single'
