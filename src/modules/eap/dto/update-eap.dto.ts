import { PartialType } from '@nestjs/mapped-types';
import { CreateEapDto } from './create-eap.dto';

export class UpdateEapDto extends PartialType(CreateEapDto) {}