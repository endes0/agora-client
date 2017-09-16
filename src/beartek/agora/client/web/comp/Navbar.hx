package beartek.agora.client.web.comp;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.event.PriEvent;
import priori.geom.PriColor;

class Navbar extends PriGroup {
  public var children : Array<Navtab> = [];
  public var min_w : Float;
  public var current_index : Int;

  public function new() {
    super();
  }

  override private function setup() : Void {
    this.bgColor = new PriColor(0x343a40);

    for( child in children ) {
      child.addEventListener('Navtab', this.on_tab);
      this.addChild(child);
    }
  }

  override private function paint() : Void {
    var w = this.width;
    var h = this.height;
    var w_elem : Float = 0;
    if( this.width > this.height ) {
      w_elem = w/(this.children.length + 1);
    } else {
      w_elem = h/(this.children.length + 1);
    }
    var padding = w_elem/this.children.length;

    var i : Int = 0;
    while( i < this.children.length ) {
      var child = this.children[i];
      if( this.width > this.height ) {
        child.width = w_elem;
        child.height = h;

        if( i != 0 ) {
          child.x = this.children[i-1].maxX + padding;
        } else {
          child.x = padding/2;
        }
      } else {
        child.width = w;
        child.height = w_elem;

        if( i != 0 ) {
          child.y = this.children[i-1].maxY + padding;
        } else {
          child.y = padding/2;
        }
      }
      i++;
    }
  }

  private function on_tab( e:PriEvent ) : Void {
    var i : Int = 0;
    while( i < this.children.length ) {
      if( this.children[i].getPrid() == e.data ) {
        break;
      } else {
        i++;
      }
    }
    if( this.current_index != null ) {
      this.children[this.current_index].set_normal();
    }
    this.current_index = i;
    this.children[i].set_selected();
    this.dispatchEvent(new PriEvent('Navchanged', this.children[i].content));
  }

}
