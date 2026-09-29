import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { BackendDataStore } from '../services/data.store';
import { TvBrandEntity, TvModelEntity } from '../entities/database.entities';

@Controller('brands')
export class BrandsController {
  private dataStore = BackendDataStore.getInstance();

  @Get()
  getAllBrands(): TvBrandEntity[] {
    return this.dataStore.brands;
  }

  @Get(':id/models')
  getModelsByBrand(@Param('id') brandId: string): TvModelEntity[] {
    return this.dataStore.models.filter((m) => m.brandId === brandId);
  }

  @Post()
  createBrand(@Body() body: { name: string; status?: 'EXPERIMENTAL' | 'TESTING' | 'SUPPORTED' | 'UNSUPPORTED' }): TvBrandEntity {
    const newBrand: TvBrandEntity = {
      id: `brand-${Date.now()}`,
      name: body.name,
      status: body.status || 'TESTING',
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    this.dataStore.brands.push(newBrand);
    return newBrand;
  }
}
