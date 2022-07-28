import { NgModule, ApplicationModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EntityViewsRoutingModule } from './entity-views-routing.module';
import { AppUserViewComponent } from './app-user-view/app-user-view.component';
import { UserRoleViewComponent } from './user-role-view/user-role-view.component';
import { DropDownListFilterComponent } from './dropdownlist-filter/dropdownlist-filter.component';
import { LibraryyViewComponent } from './libraryy-view/libraryy-view.component';
import { LibraryAgencyViewComponent } from './library-agency-view/library-agency-view.component';
import { DataProviderService } from '../../core/data/service-config';
import { ProgressServiceFactory } from '../../core/data/progress-service-factory';
import { ProgressSessionService } from '../../core/data/progress-session.service';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from '../../app-routing.module';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { GridModule, PDFModule } from '@progress/kendo-angular-grid';
import { ReactiveFormsModule } from '@angular/forms';
import { DropDownListModule } from '@progress/kendo-angular-dropdowns';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { LabelModule } from '@progress/kendo-angular-label';
import { DialogModule } from '@progress/kendo-angular-dialog';
import { AddEditAppUserComponent } from './add-edit-app-user/add-edit-app-user.component';
import { AddEditUserRoleComponent } from './add-edit-user-role/add-edit-user-role.component';
import { RentViewComponent } from './rent-view/rent-view.component';
import { AddEditRentComponent } from './add-edit-rent/add-edit-rent.component';
import { AddEditLibraryyComponent } from './add-edit-libraryy/add-edit-libraryy.component';
import { AddEditLibraryAgencyComponent } from './add-edit-library-agency/add-edit-library-agency.component';
import { RentBookViewComponent } from './rent-book-view/rent-book-view.component';
import { AddEditRentBookComponent } from './add-edit-rent-book/add-edit-rent-book.component';
import { BookTypeViewComponent } from './book-type-view/book-type-view.component';
import { BookViewComponent } from './book-view/book-view.component';
import { BookStockViewComponent } from './book-stock-view/book-stock-view.component';
import { AddEditBookStockComponent } from './add-edit-book-stock/add-edit-book-stock.component';
import { AddEditBookTypeComponent } from './add-edit-book-type/add-edit-book-type.component';
import { AddEditBookComponent } from './add-edit-book/add-edit-book.component';
import { TopTenComponent } from './top-ten/top-ten.component';
import { DateInputsModule } from '@progress/kendo-angular-dateinputs';


@NgModule({
    declarations: [
        AppUserViewComponent,
        UserRoleViewComponent,
        DropDownListFilterComponent,
        LibraryyViewComponent,
        LibraryAgencyViewComponent,
        AddEditAppUserComponent,
        AddEditUserRoleComponent,
        RentViewComponent,
        AddEditRentComponent,
        AddEditLibraryyComponent,
        AddEditLibraryAgencyComponent,
        RentBookViewComponent,
        AddEditRentBookComponent,
        AddEditBookStockComponent,
        AddEditBookTypeComponent,
        AddEditBookComponent,
        BookTypeViewComponent,
        BookViewComponent,
        BookStockViewComponent,
        TopTenComponent
    ],
    imports: [
        CommonModule,
        EntityViewsRoutingModule,
        BrowserModule,
        BrowserAnimationsModule,
        AppRoutingModule,
        HttpClientModule,
        GridModule,
        ReactiveFormsModule,
        DropDownListModule,
        InputsModule,
        DialogModule,
        LabelModule,
        ApplicationModule,
        DateInputsModule,
        PDFModule
    ],
    providers: [
        DataProviderService,
        ProgressServiceFactory,
        ProgressSessionService,
        HttpClient
    ]

})
export class EntityViewsModule { }
