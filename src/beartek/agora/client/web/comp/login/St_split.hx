package beartek.agora.client.web.comp.login;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.bootstrap.PriBSFormButton;
import priori.bootstrap.type.PriBSContextualType;
import priori.bootstrap.type.PriBSSize;
import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.view.PriImage;
import priori.style.filter.PriFilterStyle;
import priori.style.font.PriFontStyle;
import priori.style.font.PriFontStyleAlign;
import priori.style.font.PriFontStyleWeight;
import priori.geom.PriColor;
import beartek.agora.client.web.comp.Animated_gradient;
import beartek.agora.client.web.comp.Vertical_grid;

 class St_split extends PriGroup {
   var image : PriImage;
   var gradient : Animated_gradient;
   public var grid : Vertical_grid;

   public var enter_button : PriBSFormButton;
   var logo : PriText;
   var slogan : PriText;
   public function new() {
     super();
     this.enter_button = new PriBSFormButton();
   }

   override private function setup() : Void {
     this.logo = new PriText();
     this.slogan = new PriText();
     this.grid = new Vertical_grid();
     this.gradient = new Animated_gradient();
     this.image = new PriImage('backround');

     var blur = new PriFilterStyle();
     this.image.filter = blur.setBlur(3);
     this.addChild(this.image);
     this.addChild(gradient);

     this.gradient.colors = [new PriColor(0x23074d), new PriColor(0xcc5333), new PriColor(0xb20a2c), new PriColor(0xfffbd5), new PriColor(0x00b09b), new PriColor(0x283c86), new PriColor(0xe1eec3), new PriColor(0xfc6767), new PriColor(0x71B280)];
     this.gradient.alpha = 0.5;

     var fontstyle : PriFontStyle = new PriFontStyle(new PriColor(0xFFFFFF));
     fontstyle.align = PriFontStyleAlign.CENTER;
     fontstyle.weight = PriFontStyleWeight.THICK700;

     logo.fontSize = 40;
     logo.fontStyle = fontstyle;
     logo.text = 'AGORA';
     this.grid.cells[0] = new PriGroup();
     this.grid.cells[0].addChild(logo);

     slogan.fontSize = 20;
     slogan.fontStyle = fontstyle;
     var slogans : Array<String> = Jsons.slogans;
     slogan.text = slogans[Math.round(Math.random() * (slogans.length - 1))];
     this.grid.cells[1] = new PriGroup();
     this.grid.cells[1].addChild(slogan);

     this.enter_button.context = PriBSContextualType.PRIMARY;
     this.enter_button.corners = [100, 100, 100, 100];
     this.enter_button.text = 'Enter';
     this.enter_button.fontStyle = fontstyle;
     this.enter_button.size = PriBSSize.LARGE;
     this.grid.cells[2] = new PriGroup();
     this.grid.cells[2].addChild(this.enter_button);

     this.addChild(grid);
   }

   override private function paint() : Void {

     image.resizeToZoom(this.width, this.height);
     image.x = 0;
     image.y = 0;

     gradient.x = 0;
     gradient.y = 0;
     gradient.width = this.width;
     gradient.height = this.height;

     grid.centerX = this.centerX;
     grid.centerY = this.centerY;
     grid.width = 500;
     grid.height = 200;

     this.grid.cells[0].height = this.logo.height;
     this.logo.centerX = this.grid.cells[0].centerX;

     this.grid.cells[1].height = this.slogan.height;
     this.slogan.centerX = this.grid.cells[1].centerX;

     this.grid.cells[2].height = this.enter_button.height;
     this.enter_button.width = slogan.width;
     this.enter_button.centerX = this.grid.cells[2].centerX;
   }

 }
