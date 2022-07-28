import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { IvyCarouselModule } from 'angular-responsive-carousel';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ApplicationModule } from './modules/application/application.module';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { EntityViewsModule } from './modules/entity-views/entity-views.module';
import { AppLayoutComponent } from './modules/application/app-layout/app-layout.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { LoginModule } from './modules/login/login.module';
import { GridModule } from '@progress/kendo-angular-grid';
import { DropDownListModule } from '@progress/kendo-angular-dropdowns';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { LabelModule } from '@progress/kendo-angular-label';
import { DialogModule } from '@progress/kendo-angular-dialog';
import { ToastrModule } from 'ngx-toastr';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CarouselComponent } from './modules/application/carousel/carousel.component';
@NgModule({
  declarations: [
    AppComponent,
    AppLayoutComponent,
    CarouselComponent
  ],
  imports: [
    IvyCarouselModule,
    BrowserModule,
    AppRoutingModule,
    ApplicationModule,
    EntityViewsModule,
    HttpClientModule,
    ReactiveFormsModule,
    FormsModule,
    LoginModule,
    ReactiveFormsModule,
    GridModule,
    DropDownListModule,
    InputsModule,
    LabelModule,
    DialogModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(
      {
        positionClass: 'toast-top-center'
      }
    )
  ],
  providers: [
    HttpClient
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
