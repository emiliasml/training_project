import { Component, Input, EventEmitter, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderBookStock } from 'src/app/core/data/Book/book-stock.model';

@Component({
  selector: 'app-add-edit-book-stock',
  templateUrl: './add-edit-book-stock.component.html',
  styleUrls: ['./add-edit-book-stock.component.css']
})
export class AddEditBookStockComponent  {

  format = "dd/MM/yyyy";
  @Input() librarieAgencyList;
  public currentBookStock:DataProviderBookStock;
  public active = false;
  
  public editForm:FormGroup = new FormGroup({
    BookStockId:new FormControl(),
    BookId:new FormControl(),
    LibraryAgencyId:new FormControl(),
    StockAmount:new FormControl(),
    ValidFrom:new FormControl(),
    ValidTo:new FormControl(),
  });

  @Input() public isNew =false;
  
  @Input() public set model(BookStock:DataProviderBookStock){
    this.currentBookStock =BookStock;
    this.editForm.reset(BookStock);
    this.active = BookStock!== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderBookStock> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentBookStock = Object.assign(
      this.currentBookStock,
      this.editForm.value
    );
    this.save.emit(this.currentBookStock);
    this.active = false;
  }

  public onCancel(e): void {
    e.preventDefault();
    this.closeForm();
  }

  public closeForm(): void {
    this.active = false;
    this.cancel.emit();
  }

}
