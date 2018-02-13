//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web.pages;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;
import beartek.agora.types.Types;
import beartek.agora.types.Tid;

@view('../template/pages/search.html')
class Search extends HTMLComponent {
  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {

  }

  private function search() : Void {
    G_connection.g().search({contain: this.getElementsByTagName('input')[0].innerText, type: [Post_item]}, 'dash');
    js.Browser.document.getElementById('results').innerHTML = '';
  }


}
