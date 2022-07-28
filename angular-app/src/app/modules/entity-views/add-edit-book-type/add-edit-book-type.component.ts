import { Component, Input, OnInit, Output ,EventEmitter } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderBookType } from 'src/app/core/data/Book/book-type.model';

@Component({
  selector: 'app-add-edit-book-type',
  templateUrl: './add-edit-book-type.component.html',
  styleUrls: ['./add-edit-book-type.component.css']
})
export class AddEditBookTypeComponent{

  

  public currentBook:DataProviderBookType;
  public active=false;

  public editForm:FormGroup = new FormGroup({
    BookTypeId: new FormControl(),
    Description:new FormControl(),
  })

  @Input() public isNew = false;

  @Input() public set model(book: DataProviderBookType)
  {
    this.currentBook = book;
    this.editForm.reset(book);
    this.active = book !==undefined;
  }

  @Output() cancel:EventEmitter<any> =new EventEmitter();
  @Output() save: EventEmitter<DataProviderBookType> = new EventEmitter();

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
