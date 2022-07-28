import { ProgressServiceConfig } from '../progress-service-config';
import { DataProviderRoleType } from './roleType.model';

export function getRoleTypeConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'libraryProvider',
    serverOperations: true,
    createModel: () => new DataProviderRoleType(),
    jsdo: {
      name: 'SIRoleType',
    },
    ds: {
      countFnName: 'CountRoleType',
    },
  };
}