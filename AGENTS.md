# 项目约束

- 这是静态单页应用；未经明确需求，不添加后端、数据库、认证、网络请求或新依赖。
- 业务状态和持久化均在 `app/page.tsx` 的 React state 与浏览器 `localStorage`；修改数据结构时必须兼容已有 `dragon-quests`、`dragon-prep` 数据。
- 不要把用户数据写入仓库或静态资源。
- 改动后至少运行 `npm.cmd run build`。当前 `npm run lint` 和 `npm test` 不是可用验证项，原因见 `docs/DEVELOPMENT.md`。
