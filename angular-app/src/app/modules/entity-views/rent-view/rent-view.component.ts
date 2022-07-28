import { Component, OnInit, Input } from '@angular/core';
import { DataProviderRent } from '../../../core/data/Rent/rent.model';
import { getRentConfig } from '../../../core/data/Rent/rent.config';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { LibraryAgencyService } from '../../../core/auth/library-agency.service';
import { DataProviderLibraryAgency } from '../../../core/data/libraryy/library-agency.model';
import { DataProviderAppUser } from '../../../core/data/users/appUser.model';
import { AuthenticationService } from '../../../core/auth/authentication.service';
import { getAppUserConfig } from '../../../core/data/users/appUser.config';
import { FilterDescriptor } from '@progress/kendo-data-query';
import { getLibraryAgencyConfig } from '../../../core/data/libraryy/library-agency.config';
import { Observable, EMPTY } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { tap, map, catchError } from 'rxjs/operators';
import { LibraryService } from '../../../core/auth/library.service';
import { NotificationService } from '../../../core/data/notification.service';



@Component({
  selector: 'app-rent-view',
  templateUrl: './rent-view.component.html',
  styleUrls: ['./rent-view.component.css']
})
export class RentViewComponent implements OnInit {
  public currentRent: string = '';
  public state: any = {
    skip: 0,
    take: 4,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public state2: any = {
    skip: 0,
    take: 100,
  };

  public selectTextStatus = "Select Status";
  public selectTextAppUser = "Select AppUser";
  public selectTextLibraryAgency = "Select Library Agency Name";
  public editDataItem: DataProviderRent;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public appUserList: Array<DataProviderAppUser> = [];
  public statusList = [{ RentStatus: 0, Name: "opened" },
  { RentStatus: 1, Name: "finished" },
  { RentStatus: 2, Name: "on going" }];
  public libraryAgencyList: Array<DataProviderLibraryAgency> = [];
  public libraryAgencyDataService;

  constructor(private http: HttpClient, private progressServiceFactory: ProgressServiceFactory,
    public auth: AuthorizationService,
    public authentication: AuthenticationService,
    private authorization: AuthorizationService,
    private libraryAgencyService: LibraryAgencyService,
    private libraryService: LibraryService,
    private notificationService: NotificationService) {

    this.getAppUserList().subscribe(
      (result) => { },
      (error) => { console.log(error); }
    );

    this.dataService =
      this.progressServiceFactory.getService<DataProviderRent>(
        getRentConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();



    this.libraryAgencyDataService =
      this.progressServiceFactory.getService<DataProviderLibraryAgency>(
        getLibraryAgencyConfig(),
        this.state2
      );

      if (this.auth.isAuthorized({ roles: ['Admin'] }) && this.libraryAgencyService.libraryAgencyValue) {
        this.state.filter.filters = [{ field: "LibraryAgencyId", operator: "eq", value: this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId }];
      }
      if (this.auth.isAuthorized({ roles: ['User'] }) && this.libraryAgencyService.libraryAgencyValue) {
        this.state.filter.filters = [
          { field: "LibraryAgencyId", operator: "eq", value: this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId },
          { field: "AppUserId", operator: "eq", value: this.authentication.userValue.AppUserId }];
      }

      this.dataService.errors.subscribe((err) => 
      {
        if(err){
        this.notificationService.showError(err['error']['message'],"");
        this.dataService.read(this.state);}
     })
       

  }

  public ngOnInit(): void {

    this.libraryAgencyService.agency.subscribe((libraryAgency: DataProviderLibraryAgency) => {
      console.log(libraryAgency);
      if (this.auth.isAuthorized({ roles: ['Admin'] }) && libraryAgency) {
        this.state.filter.filters = [
          { field: "LibraryAgencyId", operator: "eq", value: libraryAgency.LibraryAgencyId }];
      }
      if (this.auth.isAuthorized({ roles: ['User'] }) && libraryAgency) {
        console.log("in user");
        this.state.filter.filters.filter((el: FilterDescriptor) => el.field == 'LibraryAgencyId')[0]['value'] = libraryAgency.LibraryAgencyId;
      }

      this.dataService.read(this.state);
    });

    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });

    this.libraryAgencyDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.libraryAgencyList = data['data'];
    });

    this.dataService.read(this.state);
    this.libraryAgencyDataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderRent();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(rent: DataProviderRent) {
    if (this.libraryAgencyService.libraryAgencyValue) {
      rent.LibraryAgencyId = this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId;
    }
    if (this.isNew) {
      this.dataService.create(rent);
    } else {
      this.dataService.update(rent);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    if (dataItem.RentId == this.currentRent){
      this.currentRent = "";}
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(rentGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRent = selectedData.RentId;
  }

  public appUsers(id: string): any {
    return this.appUserList.find((x) => x.AppUserId === id);
  }

  public rentStatus(id: number): any {
    return this.statusList.find((x) => x.RentStatus === id);
  }

  public libraryAgency(id: string): any {
    return this.libraryAgencyList.find((x) => x.LibraryAgencyId === id);
  }
  isAuthorized(roleList: string[]): boolean {
    return this.authorization.isAuthorized({ roles: roleList });
  }

  getAppUserList(): Observable<any> {
    const url = `${environment.serverUrl}/SIAppUser/ReadUsersFromLibrary`;

    let libraryIdForUsers = "null";

    if (this.authorization.isAuthorized(['Admin', 'User']) && this.libraryService.libraryValue.LibraryId != "all")
      libraryIdForUsers = this.libraryService.libraryValue.LibraryId;

    return this.http.put(url, {
      "request": {
        "ipcLibraryId": libraryIdForUsers
      }
    }).pipe(
      tap(response => console.log(response)),
      map((response) => {
        const result = response['response']['dsAppUser']['dsAppUser']['ttAppUser'];
        this.appUserList = result;
      }),
      catchError((err, caught) => {
        console.log(err);
        return EMPTY;
      }));

  }
}
