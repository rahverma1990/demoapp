import {Component, ElementRef, EventEmitter, HostBinding, HostListener, Input, OnInit, Output} from '@angular/core';

@Component({
  selector: 'dg-add-activity',
  templateUrl: './add-activity.component.html',
  styleUrls: ['./add-activity.component.sass']
})
export class AddActivityComponent implements OnInit {
  @Output()
  policy = new EventEmitter();
  @Output()
  policyPop = new EventEmitter();
  item = '';
  showList: Boolean = false;
  isShowActivityAdded: Boolean = false;
  nativeElement: any;
  stopEvent: Boolean = true;
  counter = 0;
  @HostBinding('style.margin-left')marginLeft = '7%';
  isShow: Boolean = false;
  @HostBinding('style.pointer-events')pointerEvent = 'auto';
  data(data) {
    this.item =  data;
    this.policy.emit(this.item);
    this.isShowActivityAdded = true;
    this.stopEvent = true;
    this.isShow = false;
    this.counter++;
    console.log(this.counter);

  }
  @HostListener('mouseenter')
  mouseenter() {
    if (!this.isShowActivityAdded) {
      this.isShow = true;
    }
  }

  @HostListener('mouseout')
  onMouseOut() {
    if (this.stopEvent) {
      this.isShow = false;
    }
  }
  @HostListener('document:click', ['$event'])
  onClick(event: Event) {
    if (event.target !== this.nativeElement && !this.nativeElement.contains(event.target)) {
      this.showList = false;
      this.isShow = false;
      this.stopEvent = true;

     } else {
       this.isShowActivityAdded = false;
      console.log("rahul");
      if (this.counter > 0) {
        console.log("removed", this.counter);
        this.policyPop.emit(this.item);
        this.counter--;
      }

    }
  }

  constructor(private _eref: ElementRef) {
    this.nativeElement = this._eref.nativeElement;
  }

  ngOnInit() {
  }
  showListPopup(event) {
    this.showList = true;
    this.stopEvent = false;
    this.isShow = true;

  }
}
