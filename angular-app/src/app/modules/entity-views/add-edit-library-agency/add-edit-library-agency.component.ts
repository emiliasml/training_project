import { Component, Input, Output, EventEmitter } from '@angular/core';
import { DataProviderLibraryAgency } from '../../../core/data/libraryy/library-agency.model';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-add-edit-library-agency',
  templateUrl: './add-edit-library-agency.component.html',
  styleUrls: ['./add-edit-library-agency.component.css']
})
export class AddEditLibraryAgencyComponent {
  @Input() libraryName: string = "here";

  public currentLibraryAgency: DataProviderLibraryAgency;
  public active = false;
  public editForm: FormGroup = new FormGroup({
    LibraryId: new FormControl(),
    Address: new FormControl(),
    LibraryAgencyName: new FormControl(),
  });
  
  @Input() public isNew = false;

  @Input() public set model(libraryAgency: DataProviderLibraryAgency) {
    this.currentLibraryAgency= libraryAgency;
    this.editForm.reset(libraryAgency);
    this.active = libraryAgency !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderLibraryAgency> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentLibraryAgency = Object.assign(
      this.currentLibraryAgency,
      this.editForm.value
    );
    this.save.emit(this.currentLibraryAgency);
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
