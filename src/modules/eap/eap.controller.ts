import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { EapService } from './eap.service';
import { CreateEapDto, UpdateEapDto } from './dto';

@Controller('api/eap')
export class EapController {
  constructor(private readonly eapService: EapService) {}

  @Get()
  findAll() {
    return this.eapService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.eapService.findOne(id);
  }

  @Post()
  create(@Body() createEapDto: CreateEapDto) {
    return this.eapService.create(createEapDto);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateEapDto: UpdateEapDto) {
    return this.eapService.update(id, updateEapDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.eapService.remove(id);
  }
}
