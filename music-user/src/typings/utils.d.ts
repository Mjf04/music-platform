/**
 * 将对象类型转换为键值对元组联合类型
 * 
 * 例如：{ a: string, b: number } 会被转换为 [a, string] | [b, number]
 * 常用于实现支持任意属性更新的泛型函数（如 Store 的 set 方法）
 */
type ObjToKeyValArray<T> = {
    [K in keyof T]: [K, T[K]];
}[keyof T];