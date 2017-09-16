package beartek.agora.client.web.pages;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import motion.Actuate;
import motion.easing.Expo;
import priori.assets.AssetManager;
import priori.scene.view.PriScene;
import priori.event.PriTapEvent;
import priori.bootstrap.PriBSFormButton;
import priori.bootstrap.type.PriBSContextualType;
import priori.bootstrap.type.PriBSSize;
import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.view.PriImage;
import priori.style.filter.PriFilterStyle;
import priori.style.font.PriFontStyle;
import priori.style.font.PriFontStyleAlign;
import priori.geom.PriColor;
import beartek.agora.client.web.comp.login.*;
import beartek.agora.client.web.comp.Animated_gradient;
import beartek.agora.client.web.comp.Vertical_grid;

 class Login extends PriScene {
   var st_split : St_split;
   var nd_split : Nd_split;
   var splited : Bool = false;

   public function new() {
     super();
   }

   override private function setup() : Void {
     st_split = new St_split();
     nd_split = new Nd_split();

     st_split.enter_button.addEventListener(PriTapEvent.TAP, this.show_menu);

     this.addChild(st_split);
     this.addChild(nd_split);
   }

   override private function paint() : Void {
     if( splited ) {
       st_split.width = this.width/2;
       nd_split.x = this.width/2;
     } else {
       st_split.width = this.width;
       nd_split.x = this.width;
     }
     st_split.height = this.height;

     nd_split.width = this.width/2;
     nd_split.height = this.height;
   }

   public function show_menu( e:PriTapEvent ) : Void {
     Actuate.tween(this.st_split, 0.8, {width: this.width/2}).ease(Expo.easeIn).onUpdate(function() {
       this.nd_split.x = this.st_split.width;
       this.st_split.paint();
       this.nd_split.paint();
     });

     st_split.grid.cells[2].removeChild(st_split.enter_button);
     splited = true;
   }

 }
