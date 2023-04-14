import type { ConnectorMetadata } from "@logto/connector-kit";
import { ConnectorPlatform } from "@logto/connector-kit";

export const authorizationEndpoint = "https://oauth.telegram.org/auth";
// Scope is set to write because we might want to send the Bot a message at some point?
export const scope = "write";

export const defaultMetadata: ConnectorMetadata = {
    id: "telegram-web",
    target: "telegram",
    platform: ConnectorPlatform.Web,
    name: {
        en: "Telegram",
        "zh-CN": "Telegram",
        "tr-TR": "Telegram",
        ko: "Telegram",
    },
    logo: "./logo.svg",
    logoDark: "./logo-dark.svg",
    description: {
        en: "Telegram is a cloud-based mobile and desktop messaging app with a focus on security and speed.",
        "zh-CN":
            "Telegram 是一款基于云的移动和桌面消息传递应用程序，专注于安全性和速度。",
        "tr-TR":
            "Telegram, güvenlik ve hıza odaklanan bulut tabanlı bir mobil ve masaüstü mesajlaşma uygulamasıdır.",
        ko: "Telegram은 보안과 속도에 중점을 둔 클라우드 기반 모바일 및 데스크톱 메시징 앱입니다.",
    },
    readme: "./README.md",
    configTemplate: "./docs/config-template.json",
};

export const defaultTimeout = 5000;
