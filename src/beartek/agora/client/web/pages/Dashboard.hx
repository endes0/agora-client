//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web.pages;

import org.tamina.html.component.HTMLComponent;

@view('../template/pages/dashboard.html')
class Dashboard extends HTMLComponent {
  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {
    for( a in this.getElementsByClassName('item five') ) {
      a.onclick = function() : Void {
        this.on_item_click(a);
      };
    }
  }

  private function on_item_click( item : js.html.Element ) : Void {
    var old = this.getElementsByClassName('item five active')[0];
    if( old != null ) {
      old.removeAttribute('id');
      old.classList.remove('active');
    }

    item.id = 'active';
    item.classList.add('active');
    var data_cmd = item.attributes.getNamedItem('data-cmd').value;
    if( data_cmd == 'logout' ) {
      Storage.remove('privkey');
      G_connection.close_connection();
    } else {
      //TODO
    }
  }

}
