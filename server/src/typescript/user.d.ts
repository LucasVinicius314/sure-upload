import { Model, Optional } from 'sequelize'
import { SequelizeBaseFieldKeys, SequelizeBaseFields } from './sequelize'

export type UserAttributes = {
  bucket: string
  key: string
} & SequelizeBaseFields

export type UserCreationAttributes = Optional<
  UserAttributes,
  SequelizeBaseFieldKeys
>

export type UserInstance = Model<UserAttributes, UserCreationAttributes> &
  UserAttributes
