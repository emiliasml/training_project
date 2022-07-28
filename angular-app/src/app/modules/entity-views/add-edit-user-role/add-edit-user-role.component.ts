import { Component, Input, Output, EventEmitter } from '@angular/core';
import { DataProviderUserRole } from '../../../core/data/users/userRole.model';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-add-edit-user-role',
  templateUrl: './add-edit-user-role.component.html',
  styleUrls: ['./add-edit-user-role.component.css']
})
export class AddEditUserRoleComponent {
  @Input() roleTypeList;
  @Input() librariesList;

  public currentUserRole: DataProviderUserRole;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    RoleTypeId: new FormControl(),
    LibraryId: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(userRole: DataProviderUserRole) {
    this.currentUserRole = userRole;
    this.editForm.reset(userRole);
    this.active = userRole !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderUserRole> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentUserRole = Object.assign(
      this.currentUserRole,
      this.editForm.value
    );
    this.save.emit(this.currentUserRole);
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
