import { Component, OnInit, Input } from '@angular/core';
import { DataProviderUserRole } from '../../../core/data/users/userRole.model';
import { DataProviderRoleType } from '../../../core/data/users/roleType.model';
import { getUserRoleConfig } from '../../../core/data/users/userRole.config';
import { getRoleTypeConfig } from '../../../core/data/users/roleType.config';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderLibraryy } from '../../../core/data/libraryy/libraryy.model';
import { getLibraryyConfig } from '../../../core/data/libraryy/libraryy.config';
import { NotificationService } from '../../../core/data/notification.service';

@Component({
  selector: 'app-user-role-view',
  templateUrl: './user-role-view.component.html',
  styleUrls: ['./user-role-view.component.css']
})
export class UserRoleViewComponent implements OnInit {
  @Input() AppUserId: string = "";

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

  public selectTextLibrary = "Select Library";
  public selectTextRoleType = "Select Role Type";
  public editDataItem: DataProviderUserRole;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public roleTypeList: Array<DataProviderRoleType> = [];
  public roleTypeDataService;
  public librariesList: Array<DataProviderLibraryy> = [];
  public libraryDataService;


  constructor(private progressServiceFactory: ProgressServiceFactory, private notificationService: NotificationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderUserRole>(
        getUserRoleConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.roleTypeDataService =
      this.progressServiceFactory.getService<DataProviderRoleType>(
        getRoleTypeConfig(),
        this.state2
      );

    this.libraryDataService =
      this.progressServiceFactory.getService<DataProviderLibraryy>(
        getLibraryyConfig(),
        this.state2
      );

    this.dataService.errors.subscribe((err) => {
      if (err) {
        this.notificationService.showError(err['error']['message'], "");
        this.dataService.read();
      }
    })
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });

    this.roleTypeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.roleTypeList = data['data'];
    });

    this.libraryDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.librariesList = data['data'];
      this.librariesList.push({ LibraryId: "all", LibraryName: "All", Description: "all", seq: 0 });
    });

    if (this.AppUserId != "") {
      this.state.filter.filters = [{ field: "AppUserId", operator: "eq", value: this.AppUserId }];
    }

    this.dataService.read(this.state);
    this.roleTypeDataService.read();
    this.libraryDataService.read();

  }

  public ngOnChanges(): void {
    if (this.AppUserId != "") {
      this.state.filter.filters = [{ field: "AppUserId", operator: "eq", value: this.AppUserId }];
    }
    this.dataService.read(this.state);
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(employee: DataProviderUserRole) {
    if (this.AppUserId != "")
      employee.AppUserId = this.AppUserId;
      
    if (this.isNew) {
      this.dataService.create(employee);
    } else {
      this.dataService.update(employee);
    }

    this.editDataItem = undefined;
  }

  public addHandler() {
    this.editDataItem = new DataProviderUserRole();
    this.isNew = true;
  }

  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public roleTypes(id: string): any {
    return this.roleTypeList.find((x) => x.RoleTypeId === id);
  }

  public libraries(id: string): any {
    return this.librariesList.find((x) => x.LibraryId === id);
  }
}

