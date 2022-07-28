import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditLibraryAgencyComponent } from './add-edit-library-agency.component';

describe('AddEditLibraryAgencyComponent', () => {
  let component: AddEditLibraryAgencyComponent;
  let fixture: ComponentFixture<AddEditLibraryAgencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditLibraryAgencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditLibraryAgencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
