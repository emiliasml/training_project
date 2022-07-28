import { ProgressServiceConfig } from './progress-service-config';
import { libraryProviderLocation } from './location.model';

export function getLocationConfig(): ProgressServiceConfig {
    return {
        dataProviderName: 'libraryProvider',
        serverOperations: false,
        createModel: () => new libraryProviderLocation(),
        jsdo: {
            name: 'LocationServiceInterface',
        },
        ds: {},
    };
}
