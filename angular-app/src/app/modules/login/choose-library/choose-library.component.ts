import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LibraryService } from '../../../core/auth/library.service';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { AuthenticationService } from '../../../core/auth/authentication.service';
import { tap, map, catchError } from 'rxjs/operators';
import { LibraryUserRole } from '../../../core/data/library-user-role.model';
import { EMPTY, Observable } from 'rxjs';

@Component({
  selector: 'app-choose-library',
  templateUrl: './choose-library.component.html',
  styleUrls: ['./choose-library.component.css']
})
export class ChooseLibraryComponent implements OnInit {

  public libraryList: Array<LibraryUserRole> = [];
  public libraryDataService;
  public currentLibrary: LibraryUserRole = null;

  constructor(
    private router: Router,
    private libraryService: LibraryService,
    private authService: AuthenticationService,
    private http: HttpClient) { }

  ngOnInit(): void {
    this.getListLibraries().subscribe(
      (error) => { console.log(error); }
    );
  }

  getListLibraries(): Observable<any> {
    const url = `${environment.serverUrl}/SILibraryUserRole/ReadLibraryUserRole`;

    return this.http
      .put(url, {
        "request": {
          "ipcAppUserId": this.authService.userValue.AppUserId,
        }
      }).pipe(
        tap(response => console.log(response)),
        map((response) => {
          const result = response['response']['dsLibraryUserRole']['dsLibraryUserRole']['ttLibraryUserRole'];
          this.libraryList = result;
          if (this.libraryList[0].RoleDescription == "Superadmin") {
            this.router.navigate(['/']);
            this.libraryService.libraryValue = this.libraryList[0];
          }
        }),
        catchError((err, caught) => {
          console.log(err);
          return EMPTY;
        })
      );
  }

  onClick(selection) {
    this.currentLibrary = selection.selectedRows[0].dataItem;
    this.libraryService.libraryValue = this.currentLibrary;
    this.router.navigate(['/']);
  }
}
