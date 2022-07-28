import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { LoginRoutingModule } from './login-routing.module';
import { LoginPageComponent } from './login-page/login-page.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { ChooseLibraryComponent } from './choose-library/choose-library.component';
import { GridModule } from '@progress/kendo-angular-grid';
import { DropDownListModule } from '@progress/kendo-angular-dropdowns';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { LabelModule } from '@progress/kendo-angular-label';
import { DialogModule } from '@progress/kendo-angular-dialog';

@NgModule({
  declarations: [
    LoginPageComponent,
    ChooseLibraryComponent
  ],
  imports: [
    DropDownListModule,
    GridModule,
    LabelModule,
    DialogModule,
    InputsModule,
    CommonModule,
    LoginRoutingModule,
    ReactiveFormsModule,
    FormsModule,
    BrowserModule
  ]
})
export class LoginModule { }
