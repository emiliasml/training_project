import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditBookStockComponent } from './add-edit-book-stock.component';

describe('AddEditBookStockComponent', () => {
  let component: AddEditBookStockComponent;
  let fixture: ComponentFixture<AddEditBookStockComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditBookStockComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditBookStockComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
