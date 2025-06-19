

import { Controller, Get, Param, Query, Res, HttpStatus } from '@nestjs/common';
import { Response } from 'express';
import * as fs from 'fs/promises';
import { join } from 'path';

@Controller()
export class DataController {
  private readonly dataDir = join(process.cwd(), 'data');

  @Get('atlas-pictures')
  async getAtlasPictures(@Query('name') name: string, @Res() res: Response) {
    try {
      if (!name) {
        return res.status(HttpStatus.BAD_REQUEST).json({ error: 'Missing name query parameter' });
      }

      const filePath = join(this.dataDir, 'atlas.txt');
      const content = await fs.readFile(filePath, 'utf8');
      const json = JSON.parse(content);

      // Normalize query name (trim + trailing plus signs)
      const searchName = name.trim().replace(/\+$/, '');

      const filtered = json.filter(entry =>
        entry.field_synonyms?.some(syn => {
          const synonyms = syn.value?.split(/\s+/).map(s => s.trim().replace(/\+$/, ''));
          return synonyms.includes(searchName);
        })
      );

      const pictures = filtered
        .flatMap(entry => entry.field_picture || [])
        .map(pic => pic.url)
        .filter(Boolean);

      return res.status(HttpStatus.OK).json({
        status: 'ok',
        count: pictures.length,
        pictures,
      });
    } catch (err) {
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        error: 'Could not read atlas.txt',
        details: err.message,
      });
    }
  }

  @Get(':filename')
  async getData(
    @Param('filename') filename: string,
    @Query('field_synonyms_value') fieldSynonymsValue: string,
    @Res() res: Response,
  ) {
    if (!/^(ion|eav|eap|atlas)$/.test(filename)) {
      return res.status(HttpStatus.BAD_REQUEST).json({
        error: 'Invalid filename. Allowed values: ion, eav, eap, atlas',
      });
    }

    try {
      const filePath = join(this.dataDir, `${filename}.txt`);
      const content = await fs.readFile(filePath, 'utf8');
      let json = JSON.parse(content);

      if (filename === 'atlas' && fieldSynonymsValue) {
        const searchName = fieldSynonymsValue.trim().replace(/\+$/, '');

        json = json.filter(entry =>
          entry.field_synonyms?.some(syn => {
            const synonyms = syn.value?.split(/\s+/).map(s => s.trim().replace(/\+$/, ''));
            return synonyms.includes(searchName);
          })
        );
      }

      return res.status(HttpStatus.OK).json(json);
    } catch (err) {
      return res.status(HttpStatus.NOT_FOUND).json({
        error: `Unable to load or parse ${filename}.txt`,
        details: err.message,
      });
    }
  }
}