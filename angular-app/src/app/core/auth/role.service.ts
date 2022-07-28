import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class RoleService {
  constructor() {}

  public getRole(): string {
    return JSON.parse(sessionStorage.getItem('library'))['RoleDescription'];
  }
}
