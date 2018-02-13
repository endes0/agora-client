//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web.pages;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;
import beartek.agora.types.Types;
import beartek.agora.types.Tid;


@view('../template/pages/dashboard.html')
class Dashboard extends HTMLComponent {
  var attached_p : Dynamic = null;

  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {
    for( a in this.getElementsByClassName('item five') ) {
      a.onclick = function() : Void {
        this.on_item_click(a);
      };
    }

    G_connection.add_response_handler('search_result', function( data : {posts: Array<Post_info>} ) : Void {
      for( post in data.posts ) {
        var column =  js.Browser.document.createElement('div');
        column.className = 'column';

        var card = HTMLApplication.createInstance(beartek.comps.Post_card);
        card.setAttribute('title', post.title);
        card.setAttribute('subtitle', post.subtitle);
        card.setAttribute('overview', post.overview);
        card.setAttribute('author', post.author.username);
        card.setAttribute('post_id', new Tid(post.id));
        card.className = 'ui fluid card';
        column.appendChild(card);

        js.Browser.document.getElementById('results').appendChild(column);
      }
    }, 'dash');
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
      js.Browser.window.location.reload();
    } else if( data_cmd == 'search' ) {
      this.set_page(beartek.agora.client.web.pages.Search);
    } else if( data_cmd == 'trends' ) {
      this.set_page(Trends);
    } else if( data_cmd == 'lasts' ) {
      this.set_page(Lasts);
    } else {
      throw 'Invalid button command';
    }
  }

  private function set_page( p : Class<Dynamic> ) : Void {
    if( this.attached_p != null ) {
      this.getElementsByClassName('fifteen wide stretched column')[0].removeChild(this.attached_p);
    }
    this.attached_p = HTMLApplication.createInstance(p);
    this.getElementsByClassName('fifteen wide stretched column')[0].appendChild(this.attached_p);
  }

}
