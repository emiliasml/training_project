import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderRentbook } from '../../../core/data/Rent/rentbook.model';
@Component({
  selector: 'app-add-edit-rent-book',
  templateUrl: './add-edit-rent-book.component.html',
  styleUrls: ['./add-edit-rent-book.component.css']
})
export class AddEditRentBookComponent  {

  @Input() bookList;
  public currentRentbook: DataProviderRentbook;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    BookId: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(rentbook: DataProviderRentbook) {
    this.currentRentbook = rentbook;
    this.editForm.reset(rentbook);

    this.active = rentbook !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRentbook> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentRentbook = Object.assign(
      this.currentRentbook,
      this.editForm.value
    );
    this.save.emit(this.currentRentbook);
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
