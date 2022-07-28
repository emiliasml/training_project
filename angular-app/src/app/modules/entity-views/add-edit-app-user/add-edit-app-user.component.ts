import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderAppUser } from '../../../core/data/users/appUser.model';

@Component({
  selector: 'app-add-edit-app-user',
  templateUrl: './add-edit-app-user.component.html',
  styleUrls: ['./add-edit-app-user.component.css']
})
export class AddEditAppUserComponent {

  public currentAppUser: DataProviderAppUser;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Name: new FormControl(),
    UserName: new FormControl(),
    Password: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(appUser: DataProviderAppUser) {
    this.currentAppUser = appUser;
    this.editForm.reset(appUser);

    this.active = appUser !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderAppUser> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentAppUser = Object.assign(
      this.currentAppUser,
      this.editForm.value
    );
    this.save.emit(this.currentAppUser);
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
