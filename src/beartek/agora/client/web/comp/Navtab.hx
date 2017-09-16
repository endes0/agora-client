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
import priori.event.PriEvent;
import priori.event.PriMouseEvent;
import priori.event.PriTapEvent;
import priori.fontawesome.PriFAIcon;

class Navtab extends PriGroup {
  public var icon : PriFAIcon;
  public var text : PriText;
  public var fontstyle : PriFontStyle;
  public var content : PriGroup;
  var _icon : String = '';
  var _title : String = '';
  var prev_bg : PriColor;

  public function new(icon : String, title : String, ?content : PriGroup ) {
    this._icon = icon;
    this._title = title;
    this.content = content;

    super();
  }

  override private function setup() : Void {
    icon = new PriFAIcon();
    text = new PriText();
    fontstyle = new PriFontStyle(new PriColor(0xFFFFFF));
    fontstyle.weight = PriFontStyleWeight.THICK500;

    icon.iconColor = 0xFFFFFF;
    icon.iconSize = 40;
    icon.icon = this._icon;
    text.fontStyle = fontstyle;
    text.text = this._title;

    this.addEventListener(PriMouseEvent.MOUSE_OVER, this.on_over);
    this.addEventListener(PriMouseEvent.MOUSE_OUT, this.on_out);
    this.addEventListener(PriTapEvent.TAP, function(e:PriEvent) : Void {
      this.dispatchEvent(new PriEvent('Navtab', this.getPrid()));
    });

    this.addChild(icon);this.addEventListener(PriMouseEvent.MOUSE_OUT, this.on_out);
    this.addChild(text);
  }

  override private function paint() : Void {
    icon.width = this.width/2;
    icon.height = 40;
    icon.centerX = this.width/2;
    icon.centerY = this.height/2 - text.height/2;

    text.width = this.width;
    text.centerX = this.width/2;
    text.y = icon.maxY -3;

  }

  public function set_normal() : Void {
    this.prev_bg = null;
    this.bgColor = this.prev_bg;
    icon.iconColor = 0xFFFFFF;
    fontstyle.color = new PriColor(0xFFFFFF);
    text.fontStyle = fontstyle;
  }

  public function set_selected() : Void {
    this.prev_bg = new PriColor(0xFFFFFF);
    this.bgColor = this.prev_bg;
    icon.iconColor = 0x343a40;
    fontstyle.color = new PriColor(0x343a40);
    text.fontStyle = fontstyle;
  }

  private function on_over( e: PriEvent ) : Void {
    this.prev_bg = this.bgColor;
    this.bgColor = new PriColor(0x464e56);
  }

  private function on_out( e: PriEvent ) : Void {
    this.bgColor = this.prev_bg;
  }

}
