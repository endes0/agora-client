//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web.pages;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;
import beartek.agora.types.Types;
import beartek.agora.types.Tid;

@view('../template/pages/lasts.html')
class Lasts extends HTMLComponent {
  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {
    G_connection.g().search({type: [Post_item], order_by: Recent_date}, 'dash');
  }


}
