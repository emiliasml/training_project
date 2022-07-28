import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { DataProviderLibraryy } from '../../../core/data/libraryy/libraryy.model';
import { getLibraryyConfig } from '../../../core/data/libraryy/libraryy.config';
import { NotificationService } from '../../../core/data/notification.service';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { LibraryService } from '../../../core/auth/library.service';


@Component({
  selector: 'app-libraryy-view',
  templateUrl: './libraryy-view.component.html',
  styleUrls: ['./libraryy-view.component.css']
})
export class LibraryyViewComponent implements OnInit {

  public currentLibraryy: string = '';
  public libraryName: string = '';

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


  public editDataItem: DataProviderLibraryy;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  constructor(private progressServiceFactory: ProgressServiceFactory,
    private notificationService: NotificationService,
    public auth: AuthorizationService,
    private libraryService: LibraryService) {
    if (this.auth.isAuthorized({ roles: ['Admin'] })) {
      this.state.filter.filters = [{ field: "LibraryId", operator: "eq", value: this.libraryService.libraryValue.LibraryId }];
      this.currentLibraryy = this.libraryService.libraryValue.LibraryId;
    }

    this.dataService =
      this.progressServiceFactory.getService<DataProviderLibraryy>(
        getLibraryyConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();
    this.dataService.errors.subscribe(
      (err) => {
        if (err) {
          console.log(err);
          this.notificationService.showError(err['error']['message'], "");
          this.dataService.read();
        }
      })
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
    this.editDataItem = new DataProviderLibraryy();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(libraryy: DataProviderLibraryy) {
    if (this.isNew) {
      this.dataService.create(libraryy);
    } else {
      this.dataService.update(libraryy);
    }
    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
    if (dataItem.LibraryId == this.currentLibraryy) {
      this.currentLibraryy = '';
      this.libraryName = '';
    }
  }

  gridUserSelectionChange(libraryyGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentLibraryy = selectedData.LibraryId;
    this.libraryName = selectedData.LibraryName;

  }

}

