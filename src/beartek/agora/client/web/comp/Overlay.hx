package beartek.agora.client.web.comp;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.fontawesome.PriFAIcon;
import priori.fontawesome.PriFaIconType;
import priori.geom.PriColor;
import priori.event.PriEvent;
import priori.event.PriTapEvent;

 class Overlay extends PriGroup {
   var bar : PriGroup = new PriGroup();
   var close_btn : PriFAIcon = new PriFAIcon();
   public var content(default,set) : PriGroup;

   public function new() {
     super();
   }

   override private function setup() : Void {
     bar.bgColor = new PriColor(0x343a40);

     close_btn.icon = PriFaIconType.CLOSE;
     close_btn.iconColor = new PriColor(0xFFFFFF);
     close_btn.iconSize = 25;
     close_btn.addEventListener(PriTapEvent.TAP, function( e:PriEvent ) : Void {
       this.kill_content();
     });

     this.addChild(bar);
     this.addChild(close_btn);
   }

   override private function paint() : Void {
     bar.width = this.width;
     bar.height = this.height/12;

     close_btn.x = bar.maxX - this.height/10;
     close_btn.centerY = bar.centerY;

     if( content != null ) {
       content.y = bar.maxY;

       content.width = this.width;
       content.height = this.height - bar.height;
     }
   }

   private function set_content( new_content : PriGroup ) : PriGroup {
     if( new_content == null ) {
       this.kill_content();
     } else {
       this.dispatchEvent(new PriEvent('on_content', content));
       if( this.content != null ) {
         this.removeChild(this.content);
       }
       this.addChild(new_content);
     }

     this.content = new_content;
     return content;
   }

   public function kill_content() : Void {
     this.dispatchEvent(new PriEvent('on_kill_content', content));
     this.removeChild(content);
     content.kill();
   }

 }
