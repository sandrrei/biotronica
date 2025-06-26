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
    origin: ['http://biotronica.duckdns.org', 'https://biotronica.duckdns.org'], // or '*' if you want
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
      .setTitle('Biotronica API')
      .setDescription('API da plataforma Biotronica')
      .setVersion('1.0')
      .build();


  //✅ Fica assim:
  //📘 Swagger UI: https://biotronica.duckdns.org:3001/api/docs
  //📄 Swagger JSON: https://biotronica.duckdns.org:3001/api-json
  //(porque SwaggerModule.setup() não altera o endpoint do JSON)
  const document = SwaggerModule.createDocument(app, config);
  
  
  SwaggerModule.setup('docs', app, document, {
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

  await app.listen(process.env.PORT ?? 3001, '0.0.0.0');
  return app;
}

bootstrap();
