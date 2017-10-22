package beartek.agora.client.web.comp;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.style.font.PriFontStyle;
import priori.style.font.PriFontStyleWeight;
import priori.geom.PriColor;

class Header extends PriGroup {
  public var name(default,set) : String = '';
  public var name_size(default,set) : Int = 45;
  public var c1(default,set) : PriColor = new PriColor(0xf44336);
  public var c2(default,set) : PriColor = new PriColor(0x2196f3);

  var title : PriText = new PriText();
  var divider : PriGroup = new PriGroup();

  public function new() {
    super();
  }

  override private function setup() : Void {
    var f_style : PriFontStyle = new PriFontStyle();
    f_style.weight = PriFontStyleWeight.THICK700;
    title.fontStyle = f_style;
    title.fontSize = name_size;
    title.text = name;
    title.setCSS('background', 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')');
    title.setCSS('background-clip', 'text');
    title.setCSS('color', 'transparent');

    divider.setCSS('background', 'linear-gradient(to right, ' + c1.toString() + ', ' + c2.toString() + ')');

    if( name != '' ) {
      this.addChild(title);
    }
    this.addChild(divider);
  }

  override private function paint() : Void {
    if( name != '' ) {
      title.centerX = this.width/2;
    }

    divider.y = if( name != '' ) title.maxY -8 else 0;
    divider.width = this.width;
    divider.centerX = this.width/2;
    divider.height = 7;

    this.height = divider.maxY;
  }

  public function set_name( name : String ) : String {
    this.name = name;
    this.title.text = name;

    this.paint();

    return name;
  }

  public function set_name_size( size : Int ) : Int {
    this.name_size = size;
    this.title.fontSize = name_size;

    this.title.fontSize = size;

    return size;
  }

  public function set_c1( color : PriColor ) : PriColor {
    this.c1 = color;

    title.setCSS('background', 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')');
    divider.setCSS('background', 'linear-gradient(to right, ' + c1.toString() + ', ' + c2.toString() + ')');

    return color;
  }

  public function set_c2( color : PriColor ) : PriColor {
    this.c2 = color;

    title.setCSS('background', 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')');
    divider.setCSS('background', 'linear-gradient(to right, ' + c1.toString() + ', ' + c2.toString() + ')');

    return color;
  }
}
