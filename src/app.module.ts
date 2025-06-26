import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthModule } from './modules/auth/auth.module';
import { RedisModule } from '@nestjs-modules/ioredis';
import { Environment } from './core/interface';
import { DataModule } from './modules/data/data.module';
import { ForumModule } from './modules/forum/forum.module';
import { EapModule } from './modules/eap/eap.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService<Environment>) => {
        const uri = configService.get<string>('MONGODB_URI');
        return { uri };
      },
      inject: [ConfigService],
    }),
    RedisModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService<Environment>) => ({
        type: 'single',
        url: `redis://${configService.get('REDIS_HOST')}:${configService.get('REDIS_PORT')}`,
      }),
      inject: [ConfigService],
    }),
    UserModule,
    AuthModule,
    DataModule,
    ForumModule,
    EapModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
