package beartek.agora.client.web.comp.post;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.geom.PriColor;
import priori.style.font.*;
import beartek.agora.types.Tid;
import beartek.agora.types.Tpost;
import beartek.agora.types.Types;
import beartek.agora.client.web.G_connection;
import htmlparser.HtmlDocument;


class Viewer extends PriGroup {
  var post_container : PriGroup = new PriGroup();
  var title : PriText = new PriText();
  var subtitle : PriText = new PriText();
  var header : Header = new Header();
  var content : PriGroup = new PriGroup();

  var id : Tid;
  var post : Tpost;

  public function new( id : Tid, ?post_info : Post_info ) {
    super();

    this.id = id;

    G_connection.add_response_handler('full_post', function( raw_post : Post ) : Void {
      this.post = new Tpost(raw_post);

      title.text = post.get().info.title;
      subtitle.text = post.get().info.subtitle;
      content.getElement().append(post.get().content.toString());
    }, 'post_viewer');

    G_connection.add_response_handler('post', function( raw_post : Post ) : Void {
      this.post = new Tpost(raw_post);

      content.getElement().append(post.get().content.toString());
    }, 'post_viewer');

    if( id != new Tid(post_info.id) && post_info == null ) {
      G_connection.g().get_post(id, true, 'post_viewer');
    } else {
      #if dummy_server
        G_connection.g().get_post(id, true, 'post_viewer');
      #else
        G_connection.g().get_post(id, false, 'post_viewer');
      #end
    }

    title.text = post_info.title;
    subtitle.text = post_info.subtitle;
  }

  override private function setup() : Void {
    this.bgColor = new PriColor(0xFFFFFF);

    post_container.getElement().addClass('card');

    var t_style : PriFontStyle = new PriFontStyle();
    t_style.weight = PriFontStyleWeight.THICK500;
    title.fontStyle = t_style;
    title.fontSize = 40;
    title.setCSS('word-break', 'break-all');
    title.setCSS('white-space', '');
    if(title.text == null) title.text = 'Loading...';

    var s_style : PriFontStyle = new PriFontStyle(0x757575);
    s_style.weight = PriFontStyleWeight.LIGHTER;
    subtitle.fontStyle = s_style;
    subtitle.fontSize = 25;
    subtitle.setCSS('word-break', 'break-all');
    subtitle.setCSS('white-space', '');
    if(title.text == null) subtitle.text = 'Loading...';

    post_container.addChild(title);
    post_container.addChild(subtitle);
    post_container.addChild(header);
    post_container.addChild(content);
    this.addChild(post_container);
  }

  override private function paint() : Void {
    post_container.width = this.width/1.1;

    post_container.y = this.y + 10;
    post_container.centerX = this.width/2;

    title.y = 3;
    title.width = post_container.width/1.6;
    title.centerX = post_container.width/2;

    subtitle.y = title.maxY;
    subtitle.width = post_container.width/1.6;
    subtitle.centerX = title.centerX;

    header.width = post_container.width/1.06;
    header.y = subtitle.maxY;
    header.centerX = title.centerX;

    content.width = post_container.width/1.06;
    content.height = null;
    content.y = header.maxY;
    content.centerX = post_container.width/2;

    post_container.height = content.maxY;
  }
}
