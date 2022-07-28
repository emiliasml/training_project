import { Injectable } from '@angular/core';
import { DataProviderLibraryAgency } from '../data/libraryy/library-agency.model';
import { Observable, BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root',
})

export class LibraryAgencyService {
    private currentLibraryAgency: DataProviderLibraryAgency;
    public agency: Observable<DataProviderLibraryAgency | null>;
    public agencySubject: BehaviorSubject<DataProviderLibraryAgency | null>;

    constructor() {
        this.agencySubject = new BehaviorSubject<DataProviderLibraryAgency | null>(null);
        this.agency = this.agencySubject.asObservable();
    }

    public get libraryAgencyValue(): DataProviderLibraryAgency | null {
        if (sessionStorage.getItem('libraryAgency')!= 'undefined')
            return JSON.parse(sessionStorage.getItem('libraryAgency'));
        return null;
    }

    public set libraryAgencyValue(LibraryAgency: DataProviderLibraryAgency) {
        this.currentLibraryAgency = LibraryAgency;
        this.agencySubject.next(LibraryAgency);
        sessionStorage.setItem('libraryAgency', JSON.stringify(this.currentLibraryAgency));
    }
}

