import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditBookTypeComponent } from './add-edit-book-type.component';

describe('AddEditBookTypeComponent', () => {
  let component: AddEditBookTypeComponent;
  let fixture: ComponentFixture<AddEditBookTypeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditBookTypeComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditBookTypeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
