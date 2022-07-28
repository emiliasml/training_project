import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { getBookTypeConfig } from 'src/app/core/data/Book/book-type.config';
import { DataProviderBookType } from 'src/app/core/data/Book/book-type.model';
import { DataProviderBook } from 'src/app/core/data/Book/book.model';
import { ProgressServiceFactory } from 'src/app/core/data/progress-service-factory';
import { NotificationService } from 'src/app/core/data/notification.service';
@Component({
  selector: 'app-book-type-view',
  templateUrl: './book-type-view.component.html',
  styleUrls: ['./book-type-view.component.css']
})
export class BookTypeViewComponent implements OnInit {
  public currentBook:string = '';
  public state: any = {
    skip: 0,
    take: 4,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public editDataItem: DataProviderBookType;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;


  constructor(private progressServiceFactory: ProgressServiceFactory,private notificationService: NotificationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderBookType>(
        getBookTypeConfig(),
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
    this.dataService.dataChanges().subscribe((data)=>{});
    this.dataService.read(this.state);

  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderBookType();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(book: DataProviderBookType) {
    if (this.isNew) {
      this.dataService.create(book);
    } else {
      this.dataService.update(book);
    }
    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(bookTypeGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentBook = selectedData.BookId;
  }


}

