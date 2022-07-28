import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentBookViewComponent } from './rent-book-view.component';

describe('RentBookViewComponent', () => {
  let component: RentBookViewComponent;
  let fixture: ComponentFixture<RentBookViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentBookViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentBookViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
