# 架构

## 运行模型

Next.js App Router 静态导出应用。根布局是 `app/layout.tsx`；唯一业务页面是客户端组件 `app/page.tsx`，对应路由 `/`。`next.config.ts` 设定 `output: "export"`，构建结果写入 `out/`。

## 模块

| 位置 | 职责 |
| --- | --- |
| `app/page.tsx` | 类型、旧数据迁移、页面状态、任务与备战事项的增删改、统计、BOSS 提取器与导出 UI。 |
| `app/quest-utils.ts` | BOSS 链接校验、CSV 转义与按投递日期筛选。 |
| `app/quest-utils.test.mjs` | 上述纯函数的最小自动化验证。 |
| `app/layout.tsx` | 全局 HTML 结构、元数据和样式导入。 |
| `app/globals.css`、`app/extras.css` | 全局与补充样式。 |
| `public/` | 页面使用的本地图片资源。 |
| `scripts/start-web.ps1`、`start-web.cmd` | Windows 本地开发启动器。 |

## 数据流

1. `Home` 首次挂载时读取 `localStorage`：`dragon-quests` 与 `dragon-prep`。
2. `migrateQuest` 和 `migratePrep` 将旧记录补全为当前结构。
3. `Quest` 记录包含可选的 `salary` 与经过 BOSS 职位链接校验的 `sourceUrl`；`migrateQuest` 为旧的 `dragon-quests` 记录补空值以保持兼容。
4. 表单与操作按钮更新 React state；统计用 `useMemo` 从 state 派生。
5. 两个 `useEffect` 在 state 更新后将数据序列化回同一组 `localStorage` 键。
6. 任务导出在浏览器中以 CSV Blob 下载；日期筛选在客户端完成，并对 CSV 公式前缀做转义。
7. 仅当用户主动使用 BOSS 提取器时，浏览器才会请求本机 `http://127.0.0.1:8000` 的健康检查和提取接口；结果只预填表单，用户确认后才写入本地存储。

没有 API 路由、服务端数据访问、数据库或状态管理库。BOSS 提取服务是独立的本机组件，不属于本项目的部署产物；浏览器本地数据不会跨设备同步。
