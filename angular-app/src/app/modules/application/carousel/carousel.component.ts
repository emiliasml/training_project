import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-carousel',
  templateUrl: './carousel.component.html',
  styleUrls: ['./carousel.component.css']
})
export class CarouselComponent implements OnInit {

  images = [
    { path: 'assets/images/welcome.png' },
    { path: 'assets/images/isometric.png' },
    { path: 'assets/images/gadgets.png' },

  ];
  constructor() { }

  ngOnInit(): void {
  }


}
