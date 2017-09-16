package beartek.agora.client.web.comp;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.event.PriEvent;
import priori.geom.PriColor;

 class Animated_gradient extends PriGroup {
   public var update_every_ms : Int = 10;
   public var speed : Int = 200;
   public var colors : Array<PriColor> = new Array();
   var second : Bool = false;
   var timer : haxe.Timer;
   var c1 : PriColor;
   var c2 : PriColor;
   var i : Int = 1;
   var color : PriColor;

   public function new() {
     super();
   }

   override private function setup() : Void {
     timer = new haxe.Timer(update_every_ms);
     timer.run = this.ontick;
     c1 = colors[0];
     c2 = colors[1];
   }

   override private function paint() : Void {
     this.updatecss();
   }

   private function ontick() : Void {
     if( c1 == null || c2 == null || color == null) {
       c1 = colors[0];
       c2 = colors[1];
       color = colors[Math.round(Math.random() * (colors.length - 1))];
     }

     if( second ) {
       c2.updateColor(this.step(color.red, c2.red, i), this.step(color.green, c2.green, i), this.step(color.blue, c2.blue, i));
     } else {
       c1.updateColor(this.step(color.red, c1.red, i), this.step(color.green, c1.green, i), this.step(color.blue, c1.blue, i));
     }

     if( i >= speed ) {
       if(second) second = false else second = true;
       color = colors[Math.round(Math.random() * (colors.length - 1))];
       i = 1;
     } else {
       i++;
     }

     this.updatecss();
   }

   private inline function step(to : Int, from : Int, i : Int) : Int {
     return Math.floor((1-i/speed) * from + (i/speed) * to);
   }

   public function updatecss() : Void {
     this.setCSS('background', 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')');
   }

 }
