 package beartek.agora.client.web.comp.cards;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import beartek.agora.client.web.comp.bs.BScard;
import beartek.agora.types.Types;

class Cards_list extends PriGroup {

  public var header : Header;
  public var cards(default,set) : Array<BScard> = [];
  public var columns : Int = 5;
  public var rows(get,null) : Int = 0;
  public var card_heigth : Float = 200;

  public function new() {
    super();

    header = new Header();
  }

  override private function setup() : Void {
    this.addChild(header);
    this.addChildList(this.cards);
  }

  override private function paint() : Void {
    this.height = this.rows * 200 + this.rows * 10 + header.height + 5;

    header.width = this.width;

    var row_y : Float = header.maxY + 5;
    var i : Int = 0;
    var last_max : Float;
    while( i < this.cards.length ) {
      last_max = 2;
      while( i < this.cards.length ) {
        var card : BScard = this.cards[i];
        card.y = row_y;
        card.x = last_max;

        card.width = this.width/columns -10 -4/columns;
        card.height = card_heigth;

        last_max = card.maxX + 10;
        i++;
        if( i%columns == 0 ) {
          break;
        }
      }

      row_y = this.cards[i-1].maxY +10;
    }
  }

  public function set_cards( cards : Array<BScard> ) : Array<BScard> {
    this.cards = cards;

    if( this._childList.length > cards.length -1 ) {
      this._childList = [];
      this.addChild(header);
      this.addChildList(cards);
    } else if( this._childList.length < cards.length -1 ) {
      this.addChildList(cards.slice(this._childList.length + 1));
    } else {
      var i : Int = 1;
      while( i < this._childList.length ) {
        if( this._childList[i] != cards[i-1] ) {
          this._childList = [];
          this.addChild(header);
          this.addChildList(cards);
          break;
        }
      }
    }

    return cards;
  }

  public function create_cards_from_post( post_infos : Array<Post_info> ) : Void {
    for( post in post_infos ) {
      var card : Post_card = new Post_card();
      card.post_info = post;

      cards.push(card);
    }
  }

  public function get_rows() : Int {
    return Math.floor(this.cards.length/columns);
  }
}
