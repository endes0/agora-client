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


class Lasts extends PriScrollableContainer {
  var lasts_posts : Cards_list;

  public function new() {
    super();
  }

  override private function setup() : Void {
    lasts_posts = new Cards_list();

    lasts_posts.header.name = 'Lasts Posts';
    G_connection.add_response_handler('search_result', function( result : Search_results ) : Void {
      lasts_posts.create_cards_from_post(result.posts);
    }, 'lasts');
    this.get_lasts_posts();

    this.addChild(lasts_posts);
  }

  override private function paint() : Void {
    lasts_posts.width = this.width/1.2;

    lasts_posts.y = 40;
    lasts_posts.centerX = this.width/2;
  }

  private inline function get_lasts_posts() : Void {
    G_connection.g().search({order_by: Recent_date}, 'lasts');
  }

}
