import { Component, Input, Output, EventEmitter } from '@angular/core';
import { DataProviderLibraryy } from '../../../core/data/libraryy/libraryy.model';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-add-edit-libraryy',
  templateUrl: './add-edit-libraryy.component.html',
  styleUrls: ['./add-edit-libraryy.component.css']
})
export class AddEditLibraryyComponent {
  public currentLibraryy: DataProviderLibraryy;
  public active = false;

  public editForm: FormGroup = new FormGroup({
    LibraryName: new FormControl(),
    Description: new FormControl(),
  })

  @Input() public isNew = false;

  @Input() public set model(libraryy: DataProviderLibraryy) {
    this.currentLibraryy = libraryy;
    this.editForm.reset(libraryy);
    this.active = libraryy !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderLibraryy> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentLibraryy = Object.assign(
      this.currentLibraryy,
      this.editForm.value
    );
    this.save.emit(this.currentLibraryy);
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
