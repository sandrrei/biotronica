// controller/forum.controller.ts
import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { ForumService } from '../service/forum.service';
import { CreatePostDto, UpdatePostDto } from '../dto';
import { AuthGuard } from 'src/core/guard/auth.guard';


@Controller('forum')
export class ForumController {
  constructor(private forumService: ForumService) {}

  @Get()
  getAllPosts() {
    return this.forumService.findAll();
  }

  @Get(':id')
  getOne(@Param('id') id: string) {
    return this.forumService.findById(id);
  }

  @UseGuards(AuthGuard)
  @Post()
  create(@Body() dto: CreatePostDto) {
    return this.forumService.create(dto);
  }

  @UseGuards(AuthGuard)
  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdatePostDto) {
    return this.forumService.update(id, dto);
  }

  @UseGuards(AuthGuard)
  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.forumService.delete(id);
  }
}
