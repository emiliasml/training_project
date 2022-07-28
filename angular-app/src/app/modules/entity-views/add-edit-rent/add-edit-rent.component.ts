import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderRent } from '../../../core/data/Rent/rent.model';
import { AuthorizationService } from '../../../core/auth/authorization.service';
@Component({
  selector: 'app-add-edit-rent',
  templateUrl: './add-edit-rent.component.html',
  styleUrls: ['./add-edit-rent.component.css']
})
export class AddEditRentComponent  {

  format = "dd/MM/yyyy";
  public currentRent: DataProviderRent;
  constructor(private authorization: AuthorizationService){}

  @Input() appUserList;
  @Input() statusList;
  @Input() libraryAgencyList;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    RentId: new FormControl(),
    AppUserId: new FormControl(),
    LibraryAgencyId: new FormControl(),
    DateFrom : new FormControl(),
    DateTo : new FormControl(),
    RentStatus : new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(rent: DataProviderRent) {
    this.currentRent = rent;
    this.editForm.reset(rent);

    this.active = rent !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRent> = new EventEmitter();
  
  public onSave(e): void {
    e.preventDefault();
    this.currentRent = Object.assign(
      this.currentRent,
      this.editForm.value
    );
    this.save.emit(this.currentRent);
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

  isAuthorized(roleList: string[]): boolean {
    return this.authorization.isAuthorized({ roles: roleList });
  }
}
