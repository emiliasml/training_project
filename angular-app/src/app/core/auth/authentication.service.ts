import { Injectable } from '@angular/core';
import { DataProviderAppUser } from '../data/users/appUser.model';
import { HttpClient } from '@angular/common/http';
import { Observable, EMPTY } from 'rxjs';
import { tap, map, catchError } from 'rxjs/operators';
import { environment } from '../../../environments/environment';
import { NotificationService } from '../data/notification.service';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService {
  private currentUser!: DataProviderAppUser;

  public get userValue(): DataProviderAppUser | null {
    return JSON.parse(sessionStorage.getItem('user'));
  }


  constructor(private http: HttpClient, private notifService: NotificationService) { }


  login(userName: string, password: string): Observable<any> {
    const url = `${environment.serverUrl}/SIAppUser/login`;
    return this.http
      .put(url, {
        "request": {
          "ipcUserName": userName,
          "ipcPassword": password
        }
      }).pipe(
        tap(response => console.log(response)),
        map((response) => {
          const result = response['response']['dsAppUser']['dsAppUser']['ttAppUser'];
          this.currentUser = result[0];
          sessionStorage.setItem('user', JSON.stringify(this.currentUser));
          return result[0];
        }),
        catchError((err, caught) => {
          console.log(err);
          this.notifService.showError("Invalid username or password", "");
          return EMPTY;
        })
      );
  }

  logout(): void {
    this.currentUser = new DataProviderAppUser();
    sessionStorage.clear();
  }
}
