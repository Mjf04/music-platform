
/**
 * 日期时间处理工具类
 * 
 * 封装了常用的日期获取与格式化功能，支持链式调用
 */
export class DateUtils {
    private date: Date;

    /**
     * 构造函数
     * 
     * @param date - 可选的日期对象，若不传则默认使用当前系统时间
     */
    constructor(date?: Date) {
        this.date = date ? date : new Date();
    }

    /**
     * 获取年份
     * 
     * @returns 四位数的年份（如 2024）
     */
    getYear(): number {
        return this.date.getFullYear();
    }

    /**
     * 获取月份
     * 
     * @returns 1 到 12 之间的月份数值
     */
    getMonth(): number {
        return this.date.getMonth() + 1;
    }

    /**
     * 获取日期（一个月中的第几天）
     * 
     * @returns 1 到 31 之间的日期数值
     */
    getDate(): number {
        return this.date.getDate();
    }

    /**
     * 获取小时数
     * 
     * @returns 0 到 23 之间的小时数值
     */
    getHours(): number {
        return this.date.getHours();
    }

    /**
     * 获取分钟数
     * 
     * @returns 0 到 59 之间的分钟数值
     */
    getMinutes(): number {
        return this.date.getMinutes();
    }

    /**
     * 获取秒数
     * 
     * @returns 0 到 59 之间的秒数值
     */
    getSeconds(): number {
        return this.date.getSeconds();
    }

    /**
     * 格式化为完整的日期时间字符串
     * 
     * @returns 格式为 "YYYY-MM-DD HH:mm:ss" 的字符串
     */
    formatDateTime(): string {
        const year = this.getYear();
        const month = String(this.getMonth()).padStart(2, '0');
        const date = String(this.getDate()).padStart(2, '0');
        const hours = String(this.getHours()).padStart(2, '0');
        const minutes = String(this.getMinutes()).padStart(2, '0');
        const seconds = String(this.getSeconds()).padStart(2, '0');

        return `${year}-${month}-${date} ${hours}:${minutes}:${seconds}`;
    }

    /**
     * 格式化为纯日期字符串
     * 
     * @returns 格式为 "YYYY-MM-DD" 的字符串
     */
    formatDate(): string {
        const year = this.getYear();
        const month = String(this.getMonth()).padStart(2, '0');
        const date = String(this.getDate()).padStart(2, '0');

        return `${year}-${month}-${date}`;
    }

    /**
     * 格式化为纯时间字符串
     * 
     * @returns 格式为 "HH:mm:ss" 的字符串
     */
    formatTime(): string {
        const hours = String(this.getHours()).padStart(2, '0');
        const minutes = String(this.getMinutes()).padStart(2, '0');
        const seconds = String(this.getSeconds()).padStart(2, '0');

        return `${hours}:${minutes}:${seconds}`;
    }
}