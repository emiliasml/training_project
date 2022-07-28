import { DataProviderLibraryAgency } from './library-agency.model';
import { ProgressServiceConfig } from '../progress-service-config';

export function getLibraryAgencyConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderLibraryAgency(),
    jsdo: {
      name: 'SILibraryAgency',
    },
    ds: {
      countFnName: 'CountLibraryAgency',
    },
  };
}
