import { Component, OnInit, Input} from '@angular/core';
import { DataProviderRentbook } from '../../../core/data/Rent/rentbook.model';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { getRentbookConfig } from '../../../core/data/Rent/rentbook.config';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderBook } from '../../../core/data/Book/book.model';
import { getBookConfig } from '../../../core/data/Book/book.config';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { NotificationService } from '../../../core/data/notification.service';


@Component({
  selector: 'app-rent-book-view',
  templateUrl: './rent-book-view.component.html',
  styleUrls: ['./rent-book-view.component.css']
})
export class RentBookViewComponent implements OnInit {

  @Input() RentId: string = "";

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
  public selectTextBooks = "Select Book";
  public editDataItem: DataProviderRentbook;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public bookList: Array<DataProviderBook> = [];
  public bookDataService;

  constructor(private progressServiceFactory: ProgressServiceFactory,
  public auth: AuthorizationService,
  private notificationService: NotificationService ) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderRentbook>(
        getRentbookConfig(),
        this.state
      );
    this.view = this.dataService.dataChanges();

    this.bookDataService =
      this.progressServiceFactory.getService<DataProviderBook>(
        getBookConfig(),
        this.state2
      );

      this.dataService.errors.subscribe((err) => 
    {if(err){
      this.notificationService.showError(err['error']['message'],"");
      this.dataService.read(this.state);}})
  

     
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => { });

    this.bookDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.bookList = data['data'];
    });

    if (this.RentId != "") {
      this.state.filter.filters = [{ field: "RentId", operator: "eq", value: this.RentId }];
    }
    this.dataService.read(this.state);
    this.bookDataService.read();
  }

  public ngOnChanges(): void {
    if (this.RentId != "") {
      this.state.filter.filters = [{ field: "RentId", operator: "eq", value: this.RentId }];
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


  public saveHandler(rent: DataProviderRentbook) {
    if (this.RentId != "")
    rent.RentId = this.RentId;
    if (this.isNew) {
      this.dataService.create(rent);
    } else {
      this.dataService.update(rent);
    }
    this.editDataItem = undefined;
  }

  public addHandler() {
    this.editDataItem = new DataProviderRentbook();
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

  public book(id: string): any {
 //   console.log(this.bookList);
    return this.bookList.find((x) => x.BookId === id);
  }


}

