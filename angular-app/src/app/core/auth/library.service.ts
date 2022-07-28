import { Injectable } from '@angular/core';
import { LibraryUserRole } from '../data/library-user-role.model';

@Injectable({
    providedIn: 'root',
})

export class LibraryService {
    private currentLibrary: LibraryUserRole;

    public get libraryValue(): LibraryUserRole | null {
        return JSON.parse(sessionStorage.getItem('library'));
    }

    public set libraryValue(library: LibraryUserRole) {
        this.currentLibrary = library;
        sessionStorage.setItem('library', JSON.stringify(this.currentLibrary));
    }
}

