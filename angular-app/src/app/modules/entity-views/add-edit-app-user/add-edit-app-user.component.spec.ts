import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditAppUserComponent } from './add-edit-app-user.component';

describe('AddEditAppUserComponent', () => {
  let component: AddEditAppUserComponent;
  let fixture: ComponentFixture<AddEditAppUserComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditAppUserComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditAppUserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
