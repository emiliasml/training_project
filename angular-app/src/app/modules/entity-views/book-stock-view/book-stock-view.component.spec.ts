import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BookStockViewComponent } from './book-stock-view.component';

describe('BookStockViewComponent', () => {
  let component: BookStockViewComponent;
  let fixture: ComponentFixture<BookStockViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BookStockViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BookStockViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
