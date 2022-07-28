import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditLibraryyComponent } from './add-edit-libraryy.component';

describe('AddEditLibraryyComponent', () => {
  let component: AddEditLibraryyComponent;
  let fixture: ComponentFixture<AddEditLibraryyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditLibraryyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditLibraryyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
