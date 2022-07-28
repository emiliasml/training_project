import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderAppUser } from '../../../core/data/users/appUser.model';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { getAppUserConfig } from '../../../core/data/users/appUser.config';
import { NotificationService } from '../../../core/data/notification.service';
import { LibraryService } from '../../../core/auth/library.service';

@Component({
  selector: 'app-app-user-view',
  templateUrl: './app-user-view.component.html',
  styleUrls: ['./app-user-view.component.css']
})
export class AppUserViewComponent implements OnInit {
  public currentAppUser: string = '';

  public state: any = {
    skip: 0,
    take: 4,
    filter: {
      logic: 'and',
      filters: [],
    },
  };
 


  public editDataItem: DataProviderAppUser;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view; 

  constructor(private progressServiceFactory: ProgressServiceFactory, private notificationService: NotificationService, private service:LibraryService) {
    this.state.filter.filters = [{ field: "AppUserId", operator: "neq", value: this.service.libraryValue.AppUserId }];
    this.dataService =
      this.progressServiceFactory.getService<DataProviderAppUser>(
        getAppUserConfig(),
        this.state
      );
    this.view = this.dataService.dataChanges();

    this.dataService.errors.subscribe((err) => 
    {if(err){
      this.notificationService.showError(err['error']['message'],"");
      this.dataService.read(this.state);}})
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
    this.dataService.read(this.state);
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderAppUser();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(appUser: DataProviderAppUser) {
    if (this.isNew) {
      this.dataService.create(appUser);
    } else {
      this.dataService.update(appUser);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    if (dataItem.AppUserId == this.currentAppUser){
     this.currentAppUser = "";}
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(appUserGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentAppUser = selectedData.AppUserId;
  }

}
