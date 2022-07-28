import { Injectable } from '@angular/core';

@Injectable()
export class AppConfigService {
  static settings: IAppConfigSettings = {
    dataProviders: {
      libraryProvider: {
        serviceUri: 'http://localhost:8810/BibliotecaWayfare',
        catalogUris: [
          'http://localhost:8810/BibliotecaWayfare/static/BibliotecaDOService.json',
        ],
        authenticationModel: 'Anonymous',
      },
    },
  } as IAppConfigSettings;
}

export interface IAppConfigSettings {
  dataProviders: any;
  authentication: any;
}

export const environmentBase: any = {
  getDataProviders(): any {
    return AppConfigService.settings.dataProviders;
  },
  getAuthentication(): any {
    return AppConfigService.settings.authentication;
  },
};

export class DataServiceConfig {
  public dataProviderName: string | undefined;
  public serverOperations = false;
  public createModel: (() => any) | undefined;
  public mapData?: (dataItem: any) => any;
}

@Injectable()
export class DataProviderService {
  public get(providerName: string|undefined): any {
    const dataProviders: any = environmentBase.getDataProviders();
    return dataProviders[providerName];
  }
}

export class DataServiceRequest {
  url: string | undefined;
  routeParams?: { [param: string]: any };
  queryString?: string;
}
