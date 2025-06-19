// service/forum.service.ts
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ForumPost } from '../model/forum-post.model';
import { Model } from 'mongoose';

@Injectable()
export class ForumService {
  constructor(
    @InjectModel(ForumPost.name) private postModel: Model<ForumPost>,
  ) {}

  findAll() {
    return this.postModel.find().exec();
  }

  findById(id: string) {
    return this.postModel.findById(id).exec();
  }

  create(data) {
    return new this.postModel(data).save();
  }

  update(id: string, data) {
    return this.postModel.findByIdAndUpdate(id, data, { new: true }).exec();
  }

  delete(id: string) {
    return this.postModel.findByIdAndDelete(id).exec();
  }
}
