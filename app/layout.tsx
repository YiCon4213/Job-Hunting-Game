import type {Metadata} from "next";
import "./globals.css";
import "./extras.css";
export const metadata:Metadata={title:"猎职勇者团｜求职讨伐记录",description:"把每次投递变成一次勇敢的讨伐。"};
export default function RootLayout({children}:Readonly<{children:React.ReactNode}>){return <html lang="zh-CN"><body>{children}</body></html>}
