import {
  AsyncModelFactory,
  Prop,
  Schema,
  SchemaFactory,
} from '@nestjs/mongoose';
import { hashSync } from 'bcryptjs';
import {
  Document,
  Schema as MongooseSchema,
  Types,
} from 'mongoose';
import {
  leanObjectId,
  leanObjectsId,
  preSave,
} from '../../../core/helper';
import { CollectionName, User } from '../../../core/interface/mongo-model';

export type Role = 'admin' | 'moderator' | 'user';

export type UserDocument = UserModel & Document;

@Schema({ timestamps: true })
export class UserModel implements User {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    required: false,
    default: () => new Types.ObjectId(),
  })
  public _id: string;

  @Prop({ type: String, required: true })
  fullname: string;

  @Prop({ type: String, unique: true, required: true })
  nickname: string;

  @Prop({
    type: String,
    select: false,
    minlength: 6,
    maxlength: 50,
    required: true,
  })
  password: string;

  @Prop({
  type: String,
  enum: ['user', 'moderator', 'admin'],
  default: 'user',
})
role: 'user' | 'moderator' | 'admin';
}


export const UserSchema = SchemaFactory.createForClass(UserModel);

export const UserFactory: AsyncModelFactory = {
  collection: CollectionName.USER,
  name: UserModel.name,
  useFactory: () => {
    // Password hashing (if needed)
    UserSchema.pre('save', async function (next) {
      const user = this as UserDocument;

      if (user.isModified('password')) {
        user.password = hashSync(user.password, 10);
      }

      next();
    });

    // Pre/post-processing
    UserSchema.post('find', leanObjectsId);
    UserSchema.post('findOne', leanObjectId);
    UserSchema.post('findOneAndUpdate', leanObjectId);

    return UserSchema;
  },
};
