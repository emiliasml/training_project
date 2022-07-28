import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppLayoutComponent } from './modules/application/app-layout/app-layout.component';
import { AppUserViewComponent } from './modules/entity-views/app-user-view/app-user-view.component';
import { BookTypeViewComponent } from './modules/entity-views/book-type-view/book-type-view.component';
import { BookViewComponent } from './modules/entity-views/book-view/book-view.component';
import { LibraryyViewComponent } from './modules/entity-views/libraryy-view/libraryy-view.component';
import { RentViewComponent } from './modules/entity-views/rent-view/rent-view.component';
import { LoginPageComponent } from './modules/login/login-page/login-page.component';
import { AuthenticationGuardService } from './core/auth/authentication-guard.service';
import { AuthorizationGuardService } from './core/auth/authorization-guard.service';
import { ChooseLibraryComponent } from './modules/login/choose-library/choose-library.component';
import { TopTenComponent } from './modules/entity-views/top-ten/top-ten.component';
import { CarouselComponent } from './modules/application/carousel/carousel.component';

const routes: Routes = [
  {
    path: '',
    component: AppLayoutComponent,
    canActivate: [AuthenticationGuardService],
    children: [
      {
        path: '',
        component: CarouselComponent,
        pathMatch: 'full'
      },
      {
        path: 'libraryy-view',
        component: LibraryyViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['Superadmin', 'Admin'],
          },
        },
      },
      {
        path: 'app-user-view',
        component: AppUserViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['Superadmin'],
          },
        },
      },
      {
        path: 'rent-view',
        component: RentViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['User', 'Admin', 'Superadmin'],
          },
        },
      },
      {
        path: 'book-view',
        component: BookViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['User', 'Admin', 'Superadmin'],
          },
        },
      },
      {
        path: 'book-type-view',
        component: BookTypeViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['Admin', 'Superadmin'],
          },
        },
      },
      {
        path: 'top-ten',
        component: TopTenComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['Admin', 'Superadmin', 'User'],
          },
        },
      }
    ],
  },
  { path: 'login', component: LoginPageComponent },
  {
    path: 'choose-library',
    component: ChooseLibraryComponent,
    canActivate: [AuthenticationGuardService],
  },
  { path: '**', redirectTo: '' },

];



@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
