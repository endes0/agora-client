//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;

@view('../template/comps/viewer.html')
class Viewer extends HTMLComponent {
  public var view(default,set) : js.html.HtmlElement;
  function set_view(v:js.html.HtmlElement) : js.html.HtmlElement {
    if( view != null ) {
      this.removeChild(view);
    }
    this.appendChild(v);
    return v;
  }

  public var title_element : js.html.Element;

  override public function attachedCallback() : Void {
    this.title_element = this.getElementsByTagName('h3')[0];
    this.className = 'fifteen wide stretched column';
    this.setAttribute('style', 'display: inline-block !important');
  }

  private function exit() : Void {
    this.remove();
    untyped $('.fifteen.wide.stretched.column').transition('slide right', function() : Void {
      js.Browser.document.getElementsByClassName('fifteen wide stretched column')[0].setAttribute('style', '');
    });
  }

}
