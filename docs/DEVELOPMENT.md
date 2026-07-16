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

## 验证

```powershell
npm.cmd run build
.\node_modules\.bin\tsc.cmd app\quest-utils.ts --outDir tmp\quest-utils --module commonjs --target ES2021 --skipLibCheck
node --test app\quest-utils.test.mjs
```

第二、三条命令验证 BOSS 链接校验、CSV 转义和导出日期范围；`tmp/` 是临时产物，不应提交。

截至 2026-07-16：

- `npm.cmd run build` 可用于完整生产构建验证。
- `npm run lint` 仍失败：脚本使用 Next.js 16 不支持的 `next lint` 命令。
- 没有可用的 `npm test` 脚本；请运行上方的 Node 测试命令。

## 数据变更

用户数据仅在浏览器本地保存。调整 `Quest`、`Prep` 或存储键时，更新 `migrateQuest`/`migratePrep` 并保留旧数据读取路径；不要在未提供迁移方案时变更存储键。
