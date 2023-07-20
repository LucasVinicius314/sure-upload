import * as fs from 'fs'
import * as multer from 'multer'
import * as yup from 'yup'

import { Router } from 'express'

export const fileRouter = Router()

// Create.

const fileSchema = yup.object({
  fileName: yup.string().required().min(3),
})

fileRouter.post(
  '/',
  multer.default().single('upload'),
  async (req, res, next) => {
    try {
      const { bucket } = req.user

      const { file } = req

      if (file === undefined) {
        res.status(400).json({
          message: 'Missing [upload] field.',
        })

        return
      }

      let { fileName } = await fileSchema.validate({
        fileName: file.originalname,
      })

      const dir = `content/${bucket}`

      fs.mkdirSync(dir, { recursive: true })

      fs.writeFileSync(`${dir}/${fileName}`, file.buffer)

      res.status(201).json({})
    } catch (error) {
      next(error)
    }
  }
)

// List.

fileRouter.get('/', async (req, res, next) => {
  try {
    const { bucket } = req.user

    const dir = `content/${bucket}`

    const files = fs.readdirSync(dir)

    res.status(200).json({
      files,
    })
  } catch (error) {
    next(error)
  }
})

// Delete.

fileRouter.delete('/:fileName', async (req, res, next) => {
  try {
    const { bucket } = req.user

    const dir = `content/${bucket}`

    let { fileName } = await fileSchema.validate(req.params)

    fileName = fileName.replace(/\//g, '').replace(/\.\./g, '')

    const filePath = `${dir}/${fileName}`

    if (!fs.existsSync(filePath)) {
      res.status(404).json({
        message: 'File does not exist.',
      })

      return
    }

    fs.unlinkSync(filePath)

    res.status(200).json({})
  } catch (error) {
    next(error)
  }
})
