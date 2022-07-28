import { ProgressServiceConfig } from "../progress-service-config";
import { DataProviderBookType } from "./book-type.model";

export function getBookTypeConfig(): ProgressServiceConfig{
    return{
        dataProviderName: 'libraryProvider',
        serverOperations: true,
        createModel: () =>new DataProviderBookType(),
        jsdo:{
            name: 'SIBookType',
        },
        ds:{
            countFnName: 'CountBookType',
        },
    };
}