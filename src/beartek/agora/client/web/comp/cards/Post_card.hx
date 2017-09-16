package beartek.agora.client.web.comp.cards;

import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.style.font.*;
import priori.event.PriEvent;
import priori.event.PriTapEvent;
import beartek.agora.client.web.comp.bs.BScard;
import beartek.agora.client.web.comp.post.Viewer;
import beartek.agora.client.web.pages.Main_page;
import beartek.agora.types.Tid;
import beartek.agora.types.Types;

class Post_card extends BScard {

    public var post_info : Post_info;
    public var title : PriText;
    public var subtitle : PriText;
    public var content : PriText;

    public function new() {
        super();

        title = new PriText();
        subtitle = new PriText();
        content = new PriText();
    }

    override private function setup() : Void {
      super.setup();

      var t_style : PriFontStyle = new PriFontStyle();
      t_style.weight = PriFontStyleWeight.THICK500;
      title.fontStyle = t_style;
      title.fontSize = 25;

      var s_style : PriFontStyle = new PriFontStyle(0x757575);
      s_style.weight = PriFontStyleWeight.LIGHTER;
      subtitle.fontStyle = s_style;
      subtitle.fontSize = 17;

      var c_style : PriFontStyle = new PriFontStyle();
      c_style.weight = PriFontStyleWeight.LIGHTER;
      content.fontStyle = c_style;

      if( post_info != null ) {
        title.text = post_info.title;
        subtitle.text = post_info.subtitle;
        content.text = post_info.overview;


        this.addEventListener(PriTapEvent.TAP, function( e:PriEvent ) : Void {
          this.dispatchEvent(new PriEvent('selected_post', this.post_info));
          Main_page.overlay.content = new Viewer(new Tid(post_info.id), post_info);
        });
      }

      if( title.text != null ) {
        this.addChild(title);
        title.setCSS('word-break', 'break-all');
        title.setCSS('white-space', '');
      }
      if( subtitle.text != null ) {
        this.addChild(subtitle);
        subtitle.setCSS('word-break', 'break-all');
        subtitle.setCSS('white-space', '');
      }
      if( content.text != null ) {
        this.addChild(content);
        content.setCSS('word-break', 'break-all');
        content.setCSS('white-space', '');
      }
    }

    override private function paint() : Void {
      title.y = 3;
      title.width = this.width/1.6;
      title.centerX = this.width/2;

      subtitle.y = title.maxY;
      subtitle.width = title.width;
      subtitle.centerX = title.centerX;

      content.y = subtitle.maxY;
      content.x = 5;
    }
}
