import { Component, OnInit, Input } from '@angular/core';
import { DataProviderLibraryAgency } from '../../../core/data/libraryy/library-agency.model';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { getLibraryAgencyConfig } from '../../../core/data/libraryy/library-agency.config';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { NotificationService } from '../../../core/data/notification.service';
import { LibraryAgencyService } from '../../../core/auth/library-agency.service';

@Component({
  selector: 'app-library-agency-view',
  templateUrl: './library-agency-view.component.html',
  styleUrls: ['./library-agency-view.component.css']
})
export class LibraryAgencyViewComponent implements OnInit {
  @Input() LibraryId: string = "";
  @Input() libraryName: string = "";

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

  public editDataItem: DataProviderLibraryAgency;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  constructor(private progressServiceFactory: ProgressServiceFactory,
    private notificationService: NotificationService,
    private libraryAgencyService: LibraryAgencyService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderLibraryAgency>(
        getLibraryAgencyConfig(),
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
      }
    )

  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => { });
    if (this.LibraryId != "") {
      this.state.filter.filters = [{ field: "LibraryId", operator: "eq", value: this.LibraryId }];
    }
    this.dataService.read(this.state);
  }

  public ngOnChanges(): void {
    if (this.LibraryId != "") {
      this.state.filter.filters = [{ field: "LibraryId", operator: "eq", value: this.LibraryId }];
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


  public saveHandler(libraryy: DataProviderLibraryAgency) {
    if (this.LibraryId != "")
      libraryy.LibraryId = this.LibraryId;
    if (this.isNew) {
      this.dataService.create(libraryy);
    } else {
      this.dataService.update(libraryy);
    }
    this.editDataItem = undefined;
    window.location.reload();
  }

  public addHandler() {
    this.editDataItem = new DataProviderLibraryAgency();
    this.isNew = true;
  }

  public removeHandler(e: any): void {
    const { dataItem } = e;

    if (dataItem["LibraryAgencyId"] == this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId) {
      this.notificationService.showError("You cannot delete the current agency!", "");
    } else {
      this.dataService.remove(dataItem);
      window.setTimeout(function () { location.reload() }, 3000)
    }
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

}
