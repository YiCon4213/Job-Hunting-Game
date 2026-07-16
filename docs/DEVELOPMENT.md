# 开发说明

## 环境

- Node.js 20.9 或更高版本
- npm

依赖版本锁定在 `package-lock.json`。常规安装使用：

```bash
npm install
```

## 本地运行与构建

```bash
npm run dev
npm run build
```

开发服务器默认监听 `http://localhost:3000`。`start-web.cmd` 是 Windows 便捷入口，会从 3000–3099 选择端口。静态构建输出在 `out/`；将该目录部署到支持静态文件的主机。

## 验证现状

截至 2026-07-15：

- `npm.cmd run build` 成功。
- `npm run lint` 失败：脚本仍使用 Next.js 16 不支持的 `next lint` 命令。
- 没有 `test` 脚本或测试文件，`npm test` 会失败。

在添加功能前，优先补上与改动范围相称的验证；不要把现有 Lint 问题误判为代码检查已经覆盖。

## 数据变更

用户数据仅在浏览器本地保存。调整 `Quest`、`Prep` 或存储键时，更新 `migrateQuest`/`migratePrep` 并保留旧数据读取路径；不要在未提供迁移方案时变更存储键。
