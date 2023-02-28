import { z } from "zod";

export const telegramConfigGuard = z.object({
    botToken: z.string(),
    origin: z.string(),
});

export type TelegramConfig = z.infer<typeof telegramConfigGuard>;

// id=<number, userid>
// first_name=<string>
// username=<telegram username>
// photo_url=<profile_pic_url, string>
// auth_date=<unix timestamp>
// hash=<hash of the data, useful for checksum validation>
export const userInfoResponseGuard = z.object({
    auth_date: z.number().optional().nullable(),
    first_name: z.string().optional().nullable(),
    hash: z.string().optional().nullable(),
    id: z.number(),
    last_name: z.string().optional().nullable(),
    photo_url: z.string().optional().nullable(),
    username: z.string().optional().nullable(),
});

export type UserInfoResponse = z.infer<typeof userInfoResponseGuard>;

export const authorizationCallbackErrorGuard = z.object({
    error: z.string(),
    error_description: z.string(),
    error_uri: z.string(),
});

export const authResponseGuard = z.object({ hash: z.string() });
