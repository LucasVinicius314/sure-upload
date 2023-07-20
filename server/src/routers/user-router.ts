import { Router } from 'express'
import { UserModel } from '../services/sequelize'

export const userRouter = Router()

// Get.

userRouter.get('/', async (req, res, next) => {
  try {
    const userId = req.user.id

    const user = await UserModel.findOne({ where: { id: userId } })

    if (user === null) {
      res.status(400).json({
        message: 'User not found.',
      })

      return
    }

    res.status(200).json({
      user,
    })
  } catch (error) {
    console.log(error)

    next(error)
  }
})
