//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;

@view('../template/comps/animated-gradient.html')
class Animated_gradient extends HTMLComponent {
  public var update_every_ms : Int = 100;
  public var speed : Int = 200;
  public var colors : Array<Array<Int>> = [];
  public var opacity : Float = 0;
  var second : Bool = false;
  var timer : haxe.Timer;
  var c1 : Array<Int>;
  var c2 : Array<Int>;
  var i : Int = 1;
  var color : Array<Int>;

  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {
    this.classList.add('gradient');

    this.colors = [[142,128,191], [242,61,76], [132,191,174], [255,210,120], [255,163,113], [157,224,171], [124,207,181], [227,239,53], [255,122,122]];
    this.c1 = this.colors[0];
    this.c2 = this.colors[1];
    this.color = this.colors[Math.round(Math.random() * (colors.length - 1))];

    this.opacity = 0.5;
    this.i = 1;
    this.second = false;
    this.update_every_ms = 50;
    this.speed = 200;

    this.timer = new haxe.Timer(update_every_ms);
    this.timer.run = this.ontick;
  }

  override public function detachedCallback() : Void {
    this.timer.stop();
  }

  override public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String) {
    switch attrName {
    case 'update_every':
      this.update_every_ms = Std.parseInt(newVal);
      timer = new haxe.Timer(update_every_ms);
    case 'speed':
      this.speed = Std.parseInt(newVal);
    case _.substr(0, 4) => 'color':
      var n : Int = Std.parseInt(attrName.substr(4));
      this.colors[n] = newVal.split(',').map(Std.parseInt);
    case 'opacity':
      this.opacity = Std.parseFloat(newVal);
    }

  }

  private function ontick() : Void {
    if( this.c1.length < 3 || this.c2.length < 3 || this.color.length < 3) {
      this.c1 = this.colors[0];
      this.c2 = this.colors[1];
      this.color = this.colors[Math.round(Math.random() * (this.colors.length - 1))];
    }

    if( second ) {
      this.c2 = [this.step(this.color[0], this.c2[0], this.i), this.step(this.color[1], this.c2[1], this.i), this.step(this.color[2], this.c2[2], this.i)];
    } else {
      this.c1 = [this.step(this.color[0], this.c1[0], this.i), this.step(this.color[1], this.c1[1], this.i), this.step(this.color[2], this.c1[2], this.i)];
    }

    if( this.i >= this.speed ) {
      if(second) second = false else second = true;
      this.color = this.colors[Math.round(Math.random() * (this.colors.length - 1))];
      this.i = 1;
    } else {
      this.i++;
    }

    this.updatecss();
  }

  private inline function step(to : Int, from : Int, i : Int) : Int {
    return Math.floor((1-i/this.speed) * from + (i/this.speed) * to);
  }

  public function updatecss() : Void {
    this.style.background = 'linear-gradient(to bottom right, rgba(' + this.c1[0] + ',' + this.c1[1] + ',' + this.c1[2] + ',' + this.opacity + '), rgba(' + this.c2[0] + ',' + this.c2[1] + ',' + this.c2[2] + ',' + this.opacity + '))';
  }


}
