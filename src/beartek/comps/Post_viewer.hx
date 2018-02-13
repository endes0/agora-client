//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;
import beartek.agora.types.Tid;
import beartek.agora.types.Types;
import beartek.agora.types.Tpost;
import beartek.agora.client.web.G_connection;

@view('../template/comps/post_viewer.html')
class Post_viewer extends HTMLComponent {
  public var post_id : Tid;

  override public function attachedCallback() : Void {
    G_connection.add_response_handler('full_post', function( post : Post ) : Void {
      var post : Tpost = new Tpost(post);

      if( Reflect.hasField(this.parentElement, 'title_element') ) {
        var title : js.html.Element =  Reflect.field(this.parentElement, 'title_element');
        title.innerText = post.get().info.title;
      }

      this.getElementsByTagName('h1')[0].innerText = post.get().info.title;
      this.getElementsByTagName('h2')[0].innerText = post.get().info.subtitle;
      this.getElementsByTagName('p')[0].innerText = post.get().info.author.username;
      this.getElementsByTagName('p')[1].innerText = post.get().info.publish_date.toString();
      this.getElementsByClassName('ui segment')[2].innerHTML = post.get().content.toString();
    }, 'post_viewer');
    G_connection.g().get_post(post_id.get(), true, 'post_viewer');
  }
}
