import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LibraryyViewComponent } from './libraryy-view.component';

describe('LibraryyViewComponent', () => {
  let component: LibraryyViewComponent;
  let fixture: ComponentFixture<LibraryyViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LibraryyViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LibraryyViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
