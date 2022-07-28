import { DataProviderLibraryy } from './libraryy.model';
import { ProgressServiceConfig } from '../progress-service-config';

export function getLibraryyConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderLibraryy(),
    jsdo: {
      name: 'SILibraryy',
    },
    ds: {
      countFnName: 'CountLibraryy',
    },
  };
}
