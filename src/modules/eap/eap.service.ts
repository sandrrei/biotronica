import { Injectable } from '@nestjs/common';
import { CreateEapDto } from './dto/create-eap.dto';
import { UpdateEapDto } from './dto/update-eap.dto';

@Injectable()
export class EapService {
  private eaps = [];

  findAll() {
    return this.eaps;
  }

  findOne(id: string) {
    return this.eaps.find(item => item.id === id);
  }

  create(createEapDto: CreateEapDto) {
    const newEap = { id: Date.now().toString(), ...createEapDto };
    this.eaps.push(newEap);
    return newEap;
  }

  update(id: string, updateEapDto: UpdateEapDto) {
    const index = this.eaps.findIndex(item => item.id === id);
    if (index === -1) return null;
    this.eaps[index] = { ...this.eaps[index], ...updateEapDto };
    return this.eaps[index];
  }

  remove(id: string) {
    const index = this.eaps.findIndex(item => item.id === id);
    if (index === -1) return null;
    const removed = this.eaps.splice(index, 1);
    return removed[0];
  }
}
