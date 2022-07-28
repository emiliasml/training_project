import { ProgressServiceConfig } from "../progress-service-config";
import { DataProviderBookStock } from "./book-stock.model";

export function getBookStockConfig(): ProgressServiceConfig{
    return{
        dataProviderName: 'libraryProvider',
        serverOperations: true,
        createModel: () =>new DataProviderBookStock(),
        jsdo:{
            name: 'SIBookStock',
        },
        ds:{
            countFnName: 'CountBookStock',
        },
    };
}