package beartek.agora.client.web.pages;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import motion.Actuate;
import priori.scene.view.PriScene;
import priori.view.container.PriGroup;
import priori.event.PriEvent;
import priori.geom.PriColor;
import priori.fontawesome.PriFaIconType;
import beartek.agora.client.web.comp.Navbar;
import beartek.agora.client.web.comp.Navtab;
import beartek.agora.client.web.comp.Overlay;
import beartek.agora.client.web.pages.mains.*;

class Main_page extends PriScene {
  var navbar : Navbar;
  var main : PriGroup;
  static public var overlay : Overlay = new Overlay();

  var has_overlay : Bool = false;

  public function new() {
    super();
  }

  override private function setup() : Void {
    navbar = new Navbar();

    navbar.children = [new Navtab(PriFaIconType.USER, 'Me'),
                      new Navtab(PriFaIconType.SEARCH, 'Search', new Search()),
                      new Navtab(PriFaIconType.FIRE, 'Trends', new Trends()),
                      new Navtab(PriFaIconType.HOURGLASS_HALF, 'Lasts', new Lasts()),
                      new Navtab(PriFaIconType.PLUS, 'New Post', new Create()),
                      new Navtab(PriFaIconType.POWER_OFF, 'Logout', new Logout())];
    navbar.addEventListener('Navchanged', this.change_main);

    this.addChild(navbar);

    Main_page.overlay.addEventListener('on_content', function( e:PriEvent ) : Void {
      this.show_overlay();
    });

    Main_page.overlay.addEventListener('on_kill_content', function( e:PriEvent ) : Void {
      this.hide_overlay();
    });
  }

  override private function paint() : Void {
    navbar.height = this.height;
    navbar.width = 100;

    if( this.main != null ) {
      this.main.height = this.height;
      this.main.width = this.width - this.navbar.width;
      this.main.x = this.navbar.maxX;
    }

    Main_page.overlay.height = this.height;
    Main_page.overlay.width = this.width - this.navbar.width;
    if( has_overlay ) {
      Main_page.overlay.x = this.navbar.maxX;
    } else {
      Main_page.overlay.x = this.maxX;
    }

  }

  private function change_main( e:PriEvent ) : Void {
    this.hide_overlay();

    this.removeChild(this.main);
    this.removeChild(Main_page.overlay);
    this.main = e.data;
    this.addChild(this.main);
    this.addChild(Main_page.overlay);
  }

  private function hide_overlay() : Void {
    Actuate.tween(Main_page.overlay, 0.8, {x: this.maxX}).onUpdate(Main_page.overlay.paint).onComplete(function() {
      this.has_overlay = false;
    });
  }

  private function show_overlay() : Void {
    Actuate.tween(Main_page.overlay, 0.8, {x: this.navbar.maxX}).onUpdate(Main_page.overlay.paint).onComplete(function() {
      this.has_overlay = true;
    });
  }

}
