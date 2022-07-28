import { ProgressServiceConfig } from "../progress-service-config";
import { DataProviderBook } from "./book.model";

export function getBookConfig(): ProgressServiceConfig{
    return{
        dataProviderName: 'libraryProvider',
        serverOperations: true,
        createModel: () =>new DataProviderBook(),
        jsdo:{
            name: 'SIBook',
        },
        ds:{
            countFnName: 'CountBook',
        },
    };
}