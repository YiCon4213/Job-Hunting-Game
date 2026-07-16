# 架构

## 运行模型

Next.js App Router 静态导出应用。根布局是 `app/layout.tsx`；唯一业务页面是客户端组件 `app/page.tsx`，对应路由 `/`。`next.config.ts` 设定 `output: "export"`，构建结果写入 `out/`。

## 模块

| 位置 | 职责 |
| --- | --- |
| `app/page.tsx` | 类型、旧数据迁移、页面状态、任务与备战事项的增删改、统计以及全部 UI 组件。 |
| `app/layout.tsx` | 全局 HTML 结构、元数据和样式导入。 |
| `app/globals.css`、`app/extras.css` | 全局与补充样式。 |
| `public/` | 页面使用的本地图片资源。 |
| `scripts/start-web.ps1`、`start-web.cmd` | Windows 本地开发启动器。 |

## 数据流

1. `Home` 首次挂载时读取 `localStorage`：`dragon-quests` 与 `dragon-prep`。
2. `migrateQuest` 和 `migratePrep` 将旧记录补全为当前结构。
3. 表单与操作按钮更新 React state；统计用 `useMemo` 从 state 派生。
4. 两个 `useEffect` 在 state 更新后将数据序列化回同一组 `localStorage` 键。

没有 API 路由、服务端数据访问、外部 HTTP 调用、数据库或状态管理库。浏览器本地数据不会跨设备同步。
