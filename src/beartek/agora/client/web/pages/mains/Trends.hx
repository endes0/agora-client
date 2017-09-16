package beartek.agora.client.web.pages.mains;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriScrollableContainer;
import priori.bootstrap.type.PriBSContextualType;
import beartek.agora.client.web.comp.cards.*;
import beartek.agora.client.web.comp.bs.BScard;
import beartek.agora.types.Types;


class Trends extends PriScrollableContainer {
  var trends_posts : Cards_list;

  public function new() {
    super();
  }

  override private function setup() : Void {
    trends_posts = new Cards_list();

    trends_posts.header.name = 'Trends Posts';
    G_connection.add_response_handler('search_result', function( result : Search_results ) : Void {
      trends_posts.create_cards_from_post(result.posts);
    }, 'trends');
    this.get_trends_posts();

    this.addChild(trends_posts);
  }

  override private function paint() : Void {
    trends_posts.width = this.width/1.2;

    trends_posts.y = 40;
    trends_posts.centerX = this.width/2;
  }

  private inline function get_trends_posts() : Void {
    G_connection.g().search({by: Most_popular}, 'trends');
  }

}
