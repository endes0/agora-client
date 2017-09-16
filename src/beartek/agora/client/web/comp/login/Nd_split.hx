package beartek.agora.client.web.comp.login;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.geom.PriColor;

 class Nd_split extends PriGroup {
   var menu : Menu;

   public function new() {
     super();
   }

   override private function setup() : Void {
     menu = new Menu();
     menu.c1 = new PriColor(0x155799);
     menu.c2 = new PriColor(0x159957);

     this.bgColor = new PriColor(0xFFFFFF);

     this.addChild(menu);
   }

   override private function paint() : Void {
     menu.width = this.width/2;
     menu.height = 300;

     menu.centerX = this.centerX - this.x;
     menu.centerY = this.centerY;
   }

 }
