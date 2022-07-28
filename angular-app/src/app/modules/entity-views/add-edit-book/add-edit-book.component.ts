import { Component, Input, OnInit, Output,EventEmitter } from '@angular/core';
import { FormGroup,FormControl, FormControlDirective } from '@angular/forms';
import { DataProviderBook } from 'src/app/core/data/Book/book.model';


@Component({
  selector: 'app-add-edit-book',
  templateUrl: './add-edit-book.component.html',
  styleUrls: ['./add-edit-book.component.css']
})
export class AddEditBookComponent  {

  @Input() bookTypeList;
  public currentBook:DataProviderBook;
  public active=false;

  public editForm:FormGroup = new FormGroup({
    Author: new FormControl(),
    BookTitle:new FormControl(),
    Publisher:new FormControl(),
    BookTypeId:new FormControl()
  })

  @Input() public isNew = false;

  @Input() public set model(book: DataProviderBook)
  {
    this.currentBook = book;
    this.editForm.reset(book);
    this.active = book !==undefined;
  }

  @Output() cancel:EventEmitter<any> =new EventEmitter();
  @Output() save: EventEmitter<DataProviderBook> = new EventEmitter();

  public onSave(e):void{
    e.preventDefault();
    this.currentBook = Object.assign(
      this.currentBook,
      this.editForm.value
    );
    this.save.emit(this.currentBook);
    this.active = false;
  }

  public onCancel(e):void{
    this.active=false;
    this.cancel.emit();
  }

  public closeForm(): void {
    this.active = false;
    this.cancel.emit();
  }
}
