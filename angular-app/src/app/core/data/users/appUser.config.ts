import { ProgressServiceConfig } from '../progress-service-config';
import { DataProviderAppUser } from './appUser.model';

export function getAppUserConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderAppUser(),
    jsdo: {
      name: 'SIAppUser',
    },
    ds: {
      countFnName: 'CountAppUser',
    },
  };
}