import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from '../../../core/auth/authentication.service';
import { LibraryService } from '../../../core/auth/library.service';
import { LibraryUserRole } from '../../../core/data/library-user-role.model';
import { AuthorizationService } from '../../../core/auth/authorization.service';
import { DataProviderLibraryAgency } from '../../../core/data/libraryy/library-agency.model';
import { getLibraryAgencyConfig } from '../../../core/data/libraryy/library-agency.config';
import { ProgressServiceFactory } from '../../../core/data/progress-service-factory';
import { LibraryAgencyService } from '../../../core/auth/library-agency.service';


@Component({
  selector: 'app-app-layout',
  templateUrl: './app-layout.component.html',
  styleUrls: ['./app-layout.component.css']
})
export class AppLayoutComponent implements OnInit {

  public userName: String = '';
  public currentLibrary: LibraryUserRole;
  public libraryAgencyList: Array<DataProviderLibraryAgency> = [];
  public libraryAgencyDataService;
  navbarOpen = false;
  public selectedValue;


  public state: any = {
    skip: 0,
    take: 100,
    filter: {
      logic: 'and',
      filters: [],
    },
  };
  constructor(private authService: AuthenticationService,
    private progressServiceFactory: ProgressServiceFactory,
    private authorization: AuthorizationService,
    private libraryService: LibraryService,
    public libraryAgencyService: LibraryAgencyService) {
    this.libraryAgencyDataService =
      this.progressServiceFactory.getService<DataProviderLibraryAgency>(
        getLibraryAgencyConfig(),
        this.state
      );
  }

  ngOnInit(): void {
    this.userName = this.authService.userValue.Name;
    this.currentLibrary = this.libraryService.libraryValue;
    this.libraryAgencyDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.libraryAgencyList = data['data'];
      if (!this.libraryAgencyService.libraryAgencyValue)
        this.libraryAgencyService.libraryAgencyValue = this.libraryAgencyList[0];
    });

    this.state.filter.filters = [{ field: "LibraryId", operator: "eq", value: this.currentLibrary.LibraryId }];
    this.libraryAgencyDataService.read();
  }

  logout(): void {
    this.authService.logout();
  }

  isAuthorized(roleList: string[]): boolean {
    return this.authorization.isAuthorized({ roles: roleList });
  }

  toggleNavbar() {
    this.navbarOpen = !this.navbarOpen;
  }


  onSelect(event: any): void {
    console.log(event);
    this.libraryAgencyService.libraryAgencyValue = event;
  }

}
