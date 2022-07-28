import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AppLayoutComponent } from './app-layout/app-layout.component';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from '../../app-routing.module';
import { ApplicationRoutingModule } from 'src/app/modules/application/application-routing.module';

@NgModule({
  declarations: [
  ],
  imports: [
  
    CommonModule,
    ApplicationRoutingModule,
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule

  ],
  providers: [
    HttpClient
  ],
  bootstrap: [AppLayoutComponent],
})
export class ApplicationModule { }
