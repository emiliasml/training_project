import { ProgressServiceConfig } from '../progress-service-config';
import { DataProviderUserRole } from './userRole.model';

export function getUserRoleConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderUserRole(),
    jsdo: {
      name: 'SIUserRole',
    },
    ds: {
      countFnName: 'CountUserRole',
    },
  };
}