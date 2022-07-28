import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { getBookStockConfig } from 'src/app/core/data/Book/book-stock.config';
import { DataProviderBookStock } from 'src/app/core/data/Book/book-stock.model';
import { ProgressServiceFactory } from 'src/app/core/data/progress-service-factory';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { DataProviderLibraryAgency } from '../../../core/data/libraryy/library-agency.model';
import { LibraryAgencyService } from '../../../core/auth/library-agency.service';
import { getLibraryAgencyConfig } from 'src/app/core/data/libraryy/library-agency.config';
import { DataProviderLibraryy } from 'src/app/core/data/libraryy/libraryy.model';
import { NotificationService } from 'src/app/core/data/notification.service';
import { getLibraryyConfig } from 'src/app/core/data/libraryy/libraryy.config';

@Component({
  selector: 'app-book-stock-view',
  templateUrl: './book-stock-view.component.html',
  styleUrls: ['./book-stock-view.component.css']
})
export class BookStockViewComponent implements OnInit {

  @Input() BookId: string = "";
  currentLibraryAgency: DataProviderLibraryAgency;
  currentLibrary:DataProviderLibraryy;

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

  public state3: any = {
    skip: 0,
    take: 100,
  };

  public selectTextLibraryAgencyName = "Select Library Agency Name";
  public selectTextLibraryName = "Select Library ";
  public editDataItem: DataProviderBookStock;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public LibrariesList: Array<DataProviderLibraryAgency> = [];
  public LibrariesName: Array<DataProviderLibraryy> = [];
  public LibraryDataService;
  public LibraryNameDataService;


  constructor(private progressServiceFactory: ProgressServiceFactory,
    public auth: AuthorizationService,
    private libraryAgencyService: LibraryAgencyService,private notificationService: NotificationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderBookStock>(
        getBookStockConfig(),
        this.state
      );
    this.view = this.dataService.dataChanges();

    this.LibraryDataService =
      this.progressServiceFactory.getService<DataProviderLibraryAgency>(
        getLibraryAgencyConfig(),
        this.state2
      );
    
    this.LibraryNameDataService=
        this.progressServiceFactory.getService<DataProviderLibraryy>(
          getLibraryyConfig(),
          this.state3
        );

    if (this.auth.isAuthorized({ roles: ['Admin', 'User'] }) && this.libraryAgencyService.libraryAgencyValue) {
      this.state.filter.filters = [
        { field: "LibraryAgencyId", operator: "eq", value: this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId },
        { field: "BookId", operator: "eq", value: this.BookId }];
    }

    this.dataService.errors.subscribe((err) => 
    {if(err){
      this.notificationService.showError(err['error']['message'],"");
      this.dataService.read(this.state);}})
  }

  public ngOnInit(): void {
    if (this.BookId != "") {
      this.state.filter.filters = [
        { field: "BookId", operator: "eq", value: this.BookId }];
    }
    this.libraryAgencyService.agency.subscribe((libraryAgency: DataProviderLibraryAgency) => {
      console.log(libraryAgency);
      if (this.auth.isAuthorized({ roles: ['Admin', 'User'] }) && libraryAgency) {
        this.state.filter.filters = [
          { field: "LibraryAgencyId", operator: "eq", value: libraryAgency.LibraryAgencyId },
          { field: "BookId", operator: "eq", value: this.BookId }];
      }

      this.LibraryNameDataService.dataChanges().subscribe((data) =>{
        if( data && data['data'])
            this.LibrariesName = data['data'];
      });
      this.dataServiceData = this.dataService.dataChanges();
      this.LibraryNameDataService.read();
      this.currentLibraryAgency = this.libraryAgencyService.libraryAgencyValue;
      this.dataService.dataChanges().subscribe((data) => { });
      this.dataService.read(this.state);
    });
  }

  public ngOnChanges(): void {
    if (this.BookId != "") {
      this.state.filter.filters = [
        { field: "BookId", operator: "eq", value: this.BookId }];
    }
    
    if (this.auth.isAuthorized({ roles: ['Admin', 'User'] }) && this.BookId != "" &&  this.libraryAgencyService.libraryAgencyValue) {
      this.state.filter.filters = [
        { field: "LibraryAgencyId", operator: "eq", value: this.libraryAgencyService.libraryAgencyValue.LibraryAgencyId },
        { field: "BookId", operator: "eq", value: this.BookId }];
    }

    this.LibraryDataService.dataChanges().subscribe((data) => {
      if (data && data['data'])
        this.LibrariesList = data['data'];
    });

    this.dataService.read(this.state);

    this.LibraryDataService.read();
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }


  public saveHandler(book: DataProviderBookStock) {
    if (this.BookId != "")
      book.BookId = this.BookId;
    if (this.isNew) {
      this.dataService.create(book);
    } else {
      this.dataService.update(book);
    }
    this.editDataItem = undefined;
  }

  public addHandler() {
    this.editDataItem = new DataProviderBookStock();
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

  public libraries(id: string): any {
    return this.LibrariesList.find((x) => x.LibraryAgencyId === id);
  }

  public librariesName(id: string): any {
    return this.LibrariesName.find((x) => x.LibraryId === id);
  }

}

