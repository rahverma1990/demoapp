import {Component, ElementRef, EventEmitter, HostListener, Input, OnInit, Output} from '@angular/core';

export const List = [
  {
    id: 1,
    name : 'HTTP Request',
    description: 'request'
  },
  {
    id: 2,
    name: 'throttling',
    description: 'request'
  },
  {
    id: 3,
    name: 'Caching',
    description: 'request'
  }
];
@Component({
  selector: 'dg-list-activities',
  templateUrl: './list-activities.component.html',
  styleUrls: ['./list-activities.component.sass']
})
export class ListActivitiesComponent implements OnInit {
  @Input()
  isListVisible: Boolean;
  @Output()
  selected = new EventEmitter();
  list = List;
  nativeElement: any;

  ngOnInit() {
  }


  select(item) {
this.selected.emit(item);
this.isListVisible = false;
  }

}
