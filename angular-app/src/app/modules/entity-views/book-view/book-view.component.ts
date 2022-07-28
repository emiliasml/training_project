import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent} from '@progress/kendo-angular-grid';
import { DataProviderBook } from 'src/app/core/data/Book/book.model';
import { getBookConfig } from 'src/app/core/data/Book/book.config';
import { ProgressServiceFactory } from 'src/app/core/data/progress-service-factory';
import { DataProviderBookType } from 'src/app/core/data/Book/book-type.model';
import { getRoleTypeConfig } from 'src/app/core/data/users/roleType.config';
import { getBookTypeConfig } from 'src/app/core/data/Book/book-type.config';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { DataProviderLibraryy } from 'src/app/core/data/libraryy/libraryy.model';
import { getLibraryyConfig } from 'src/app/core/data/libraryy/libraryy.config';
import { NotificationService } from 'src/app/core/data/notification.service';
@Component({
  selector: 'app-book-view',
  templateUrl: './book-view.component.html',
  styleUrls: ['./book-view.component.css']
})

export class BookViewComponent implements OnInit {

  public currentBook:string = '';
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

  public selectTextBooks = "Select BookType";
  public editDataItem: DataProviderBook;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public BookTypeList:Array<DataProviderBookType> = [];
  public BookTypeDataService;


  constructor(private progressServiceFactory: ProgressServiceFactory,
  public auth:AuthorizationService, private notificationService: NotificationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderBook>(
        getBookConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.BookTypeDataService = 
        this.progressServiceFactory.getService<DataProviderBookType>(
          getBookTypeConfig(),
          this.state2
        );

    this.dataService.errors.subscribe((err) => 
    {if(err){
      this.notificationService.showError(err['error']['message'],"");
      this.dataService.read(this.state);}})
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();

    this.BookTypeDataService.dataChanges().subscribe((data) =>{
      if( data && data['data'])
          this.BookTypeList = data['data'];
    });

    this.dataService.dataChanges().subscribe((data) => {
    });
    this.dataService.read(this.state);
    
    this.BookTypeDataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderBook();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(book: DataProviderBook) {
    if (this.isNew) {
      this.dataService.create(book);
    } else {
      this.dataService.update(book);
    }
    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    if(dataItem.BookId == this.currentBook){
     this.currentBook = "";
    }
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(bookGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentBook = selectedData.BookId;
  }

  public bookTypes(id: string):any{
    return this.BookTypeList.find((x) => x.BookTypeId === id);
  }

} 
