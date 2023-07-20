import { UserAttributes } from './user'

declare global {
  namespace Express {
    interface Request {
      user: UserAttributes
    }
  }

  namespace NodeJS {
    interface ProcessEnv {
      DATABASE_URL: string
      JWT_SECRET: string
      PORT: string
    }
  }
}

export {}
