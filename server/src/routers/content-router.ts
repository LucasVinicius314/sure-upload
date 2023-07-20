import * as fs from 'fs'
import * as yup from 'yup'

import { Router } from 'express'

export const contentRouter = Router()

// Get.

const paramsSchema = yup.object({
  bucket: yup.string().required(),
  fileName: yup.string().required().min(3),
})

const querySchema = yup.object({
  mode: yup.string().required(),
})

contentRouter.get('/:bucket/:fileName', async (req, res, next) => {
  try {
    let { bucket, fileName } = await paramsSchema.validate(req.params)
    const { mode } = await querySchema.validate(req.query)

    bucket = bucket.replace(/\//g, '').replace(/\.\./g, '')
    fileName = fileName.replace(/\//g, '').replace(/\.\./g, '')

    const filePath = `${bucket}/${fileName}`

    if (!fs.existsSync(`content/${filePath}`)) {
      res.status(404).json({
        message: 'File does not exist.',
      })

      return
    }

    if (mode === 'download') {
      res.status(200).sendFile(filePath, { root: 'content' })

      return
    } else if (mode === 'embed') {
      res.status(500).json({
        // TODO: fix
        message: 'Missing implementation.',
      })
    } else {
      res.status(400).json({
        message:
          'Invalid query param mode. Specify either ?mode=download or ?mode=embed.',
      })

      return
    }
  } catch (error) {
    next(error)
  }
})
