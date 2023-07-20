import * as yup from 'yup'

import { Router } from 'express'
import { UserModel } from '../services/sequelize'
import { signJwt } from '../utils/jwt'

export const authRouter = Router()

// Login.

const loginSchema = yup.object({
  key: yup.string().required(),
})

authRouter.post('/login', async (req, res, next) => {
  try {
    const { key } = await loginSchema.validate(req.body)

    const userInstance = await UserModel.findOne({
      where: { key },
    })

    if (userInstance === null) {
      res.status(401).json({})

      return
    }

    const signedJwt = signJwt(userInstance.dataValues)

    res.status(200).json({
      token: signedJwt,
    })
  } catch (error) {
    next(error)
  }
})
