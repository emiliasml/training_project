import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditRentBookComponent } from './add-edit-rent-book.component';

describe('AddEditRentBookComponent', () => {
  let component: AddEditRentBookComponent;
  let fixture: ComponentFixture<AddEditRentBookComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditRentBookComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditRentBookComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
