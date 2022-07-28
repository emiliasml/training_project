import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LibraryAgencyViewComponent } from './library-agency-view.component';

describe('LibraryAgencyViewComponent', () => {
  let component: LibraryAgencyViewComponent;
  let fixture: ComponentFixture<LibraryAgencyViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LibraryAgencyViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LibraryAgencyViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
