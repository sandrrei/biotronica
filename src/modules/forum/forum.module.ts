// forum.module.ts
import { Module } from '@nestjs/common';
import { ForumController } from './controller/forum.controller';
import { ForumService } from './service/forum.service';
import { MongooseModule } from '@nestjs/mongoose';
import { ForumPost, ForumPostSchema } from './model/forum-post.model';

@Module({
  imports: [MongooseModule.forFeature([{ name: ForumPost.name, schema: ForumPostSchema }])],
  controllers: [ForumController],
  providers: [ForumService],
})
export class ForumModule {}
