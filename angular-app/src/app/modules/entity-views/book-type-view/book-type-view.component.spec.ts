import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BookTypeViewComponent } from './book-type-view.component';

describe('BookTypeViewComponent', () => {
  let component: BookTypeViewComponent;
  let fixture: ComponentFixture<BookTypeViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BookTypeViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BookTypeViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
