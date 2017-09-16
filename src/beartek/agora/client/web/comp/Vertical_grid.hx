package beartek.agora.client.web.comp;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
 import priori.view.container.PriGroup;


 class Vertical_grid extends PriGroup {
   public var cells : Array<PriGroup> = new Array();
   public var padding : Int = 10;
   public var centered : Bool = true;

   public function new() {
     super();
   }

   override private function setup() : Void {
     for( cell in cells ) {
       this.addChild(cell);
     }
   }

   override private function paint() : Void {
     var pos : Float = this.y;
     for( cell in cells ) {
       cell.y = pos;
       if( centered ) cell.x = this.centerX - this.width/2 else cell.x = this.x;

       cell.width = this.width;

       pos = pos + cell.height + padding;
     }

     //this.height = pos;
   }

 }
