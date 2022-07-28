import { ProgressServiceConfig } from '../progress-service-config';
import { DataProviderRentbook } from './rentbook.model';

export function getRentbookConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderRentbook(),
    jsdo: {
      name: 'SIRentBook',
    },
    ds: {
      countFnName: 'CountRentBook',
    },
  };
}