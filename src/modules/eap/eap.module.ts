import { Module } from '@nestjs/common';
import { EapController } from './eap.controller';
import { EapService } from './eap.service';

@Module({
  controllers: [EapController],
  providers: [EapService],
})
export class EapModule {}
