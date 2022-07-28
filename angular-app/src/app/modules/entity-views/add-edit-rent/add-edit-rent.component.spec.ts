import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditRentComponent } from './add-edit-rent.component';

describe('AddEditRentComponent', () => {
  let component: AddEditRentComponent;
  let fixture: ComponentFixture<AddEditRentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditRentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditRentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
