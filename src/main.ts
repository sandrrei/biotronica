import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { configDotenv } from 'dotenv';
import { ValidationPipe } from '@nestjs/common';
import { AllExceptionFilter } from './core/filter/all-exception.filter';
import { TransformInterceptor } from './core/interceptor/transform.inceptor';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as express from 'express';
import { join } from 'path';

configDotenv();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Add this line to prefix all routes with /api
  app.setGlobalPrefix('api');

  app.enableCors({
    origin: ['http://ryodo.duckdns.org', 'https://ryodo.duckdns.org'], // or '*' if you want
    credentials: true,
  });

  // ✅ Serve /data/*.txt files
  app.use('/data', express.static(join(__dirname, '..', 'data')));

  // ✅ Log every request and response
  app.use((req, res, next) => {
    const start = Date.now();
    console.log(`➡️  ${req.method} ${req.url}`);

    res.on('finish', () => {
      const duration = Date.now() - start;
      console.log(`⬅️  ${res.statusCode} ${res.statusMessage} (${duration}ms)`);
    });

    next();
  });

  const config = new DocumentBuilder()
    .setTitle('NestJS TODO Playground API')
    .setDescription('The NestJS TODO Playground API description')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const documentFactory = () => SwaggerModule.createDocument(app, config);
  
  // Swagger UI at /docs (not /api/docs)
  SwaggerModule.setup('api/docs', app, documentFactory, {
    swaggerOptions: { persistAuthorization: true },
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.useGlobalFilters(new AllExceptionFilter());
  app.useGlobalInterceptors(new TransformInterceptor());

  await app.listen(process.env.PORT ?? 3000);
  return app;
}

bootstrap();
