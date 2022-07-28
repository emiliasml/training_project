import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TopTen } from '../../../core/data/top-ten/top-ten.model';
import { environment } from '../../../../environments/environment';
import { tap, map, catchError } from 'rxjs/operators';
import { EMPTY, Observable } from 'rxjs';
import { NotificationService } from '../../../core/data/notification.service';

@Component({
  selector: 'app-top-ten',
  templateUrl: './top-ten.component.html',
  styleUrls: ['./top-ten.component.css']
})
export class TopTenComponent implements OnInit {

  public topTenList: Array<TopTen> = [];
  public requestTable: string = '';
  public sendCSV: boolean = false;
  public pdfName: string = '';
  public description: string = '';
  public number: string = '';

  constructor(private http: HttpClient, private notificationService: NotificationService) { }

  ngOnInit(): void {
  }


  getTopTenList(): Observable<any> {
    const url = `${environment.serverUrl}/SICSVReports/TopTen`;

    return this.http.put(url, {
      "request": {
        "iplSendCSV": this.sendCSV,
        "ipcTopTen": this.requestTable
      }
    }).pipe(
      tap(response => console.log(response)),
      map((response) => {
        const result = response['response']['dsTopTen']['dsTopTen']['ttTopTen'];
        this.topTenList = result;
      }),
      catchError((err, caught) => {
        console.log(err);
        this.notificationService.showError(err, "");
        return EMPTY;
      }));
  }

  getRequestTable(str: string): void {
    this.requestTable = str;
    this.sendCSV = false;
    this.pdfName = this.requestTable + ".pdf";
    this.setHeaders(this.requestTable);
    this.getTopTenList().subscribe(
      (error) => {
        if (error) {
          this.notificationService.showError(error, "");
        }
      }
    )
  }

  getCSV() {
    this.sendCSV = true;
    this.getTopTenList().subscribe(
      (result) => {
        this.notificationService.showSuccess("Success!", "");
      }
    );
  }

  setHeaders(str: string) {
    if (str == 'TopTenBooks') {
      this.description = "Book Type";
      this.number = "Number of books"
    }
    else
      if (str == 'TopTenRentedBooks') {
        this.description = "Book Title, Author, Type ";
        this.number = "Number of rents"
      }
      else
        if (str == 'TopTenActiveUsers') {
          this.description = "Name, Username ";
          this.number = "Number of rents"
        }
        else if (str == 'TopTenLibrariesByUsers') {
          this.description = "Library Name, Number of Agencies ";
          this.number = "Number of users"
        }
  }
}
