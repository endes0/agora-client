package beartek.agora.client.web.pages.mains;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.fontawesome.PriFaIconType;
import priori.fontawesome.PriFAIcon;
import priori.view.container.PriScrollableContainer;
import priori.view.text.PriText;
import priori.bootstrap.PriBSFormInputText;
import priori.bootstrap.PriBSFormButton;
import priori.bootstrap.type.PriBSContextualType;
import priori.event.PriEvent;
import priori.event.PriTapEvent;
import priori.event.PriFocusEvent;
import beartek.agora.client.web.comp.cards.*;
import beartek.agora.client.web.comp.bs.BScard;
import beartek.agora.types.Types;

class Search extends PriScrollableContainer {
  var search : PriBSFormInputText;
  var search_button : PriBSFormButton;
  var search_icon : PriFAIcon;
  var result : Cards_list;

  public function new() {
    super();
  }

  override private function setup() : Void {
    search = new PriBSFormInputText();
    search_button = new PriBSFormButton();
    search_icon = new PriFAIcon();
    result = new Cards_list();

    search.placeholder = 'Search';
    search.tooltip = search.placeholder;
    search.getElement().children().css('border-radius', '100px 0px 0px 100px');
    search.addEventListener(PriFocusEvent.FOCUS_OUT, this.show_result);

    search_icon.icon = PriFaIconType.SEARCH;
    search_icon.iconColor = 0xFFFFFF;
    search_button.text = '';
    search_button.getElement().children().children('.bs_button_label').append(search_icon.getElement().children());
    search_button.context = PriBSContextualType.INFO;
    search_button.corners = [0,100,100,0];
    search_button.addEventListener(PriTapEvent.TAP, this.show_result);

    result.header.name = 'Random posts';
    G_connection.add_response_handler('search_result', function( results : Search_results ) : Void {
      result.create_cards_from_post(results.posts);
    }, 'search_results');
    this.get_random_result();

    this.addChild(search);
    this.addChild(search_button);
    this.addChild(result);
  }

  override private function paint() : Void {
    search.y = 80;
    search_button.y = search.y;

    search.width = this.width/2;
    search_button.width = search.width/4;
    search_button.height = search.height;

    search.x = this.width/2 - (this.search.width + this.search_button.width)/2;
    search_button.x = search.maxX -3;

    result.width = this.width/1.2;

    result.y = search.maxY + 20;
    result.centerX = this.width/2;
  }

  private inline function get_random_result() : Void {
    G_connection.g().search({}, 'search_results');
  }

  private function show_result( e : PriEvent ) : Void {
    if( search.value != '' ) {
      this.result.header.name = 'Results';
      this.result.cards = [];

      G_connection.g().search({contain: search.value}, 'search_results');
    } else {
      this.result.header.name = 'Random posts';
      this.result.cards = [];
      this.get_random_result();
    }
  }

}
