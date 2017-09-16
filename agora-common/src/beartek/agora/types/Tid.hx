package beartek.agora.types;

import beartek.agora.types.Types;

abstract Tid(Id) {

  static var items_word : Map<String, String> = ['User_item' => 'u', 'Post_item' => 'p', 'Sentence_item' => 's'];

  public inline function new( id : Id ) {
    var invalid_host = ~/[^a-zA-Z0-9&*@._+-]+/i;
    if(id.host == null || id.host == '' || id.host.length > 64 || invalid_host.match(id.host)) throw 'Invalid host.';
    if(id.first.length != 2 || id.second.length != 2 || id.third.length != 2) throw 'Invalid id values lenght.';

    this = id;
  }

  @:to
  public inline function toString() : String {
    var type : String = if( items_word.exists(Type.enumConstructor(this.type)) ) {
      items_word[Type.enumConstructor(this.type)];
    } else {
      'd';
    }

    return this.host + '/' + type + '/' + this.first + '/' + this.second + '/' + this.third;
  }

  @:from
  public static function fromString( id : String ) : Tid {
    var match = ~/([a-zA-Z0-9&*@._+-]+)\/(\W)\/([^ \/\\])\/([^ \/\\])\/([^ \/\\])/i;
    if(!match.match(id)) throw 'Invalid Id format.';

    return new Tid({host: match.matched(1), type: get_item_from_word(match.matched(2)), first: match.matched(3), second: match.matched(4), third: match.matched(5)});
  }

  public inline function fromURI( uri : String ) : Tid {
    if(StringTools.startsWith(uri, 'web+agora://')) return fromString(uri.substr(12)) else throw 'Invalid URI.';
  }

  public static function exist_item_word( word : String ) : Bool {
    for( item_word in items_word ) {
      if( item_word == word ) {
        return true;
      }
    }

    return false;
  }

  public static function get_item_from_word( word : String ) : Items_types {
    for( item in items_word.keys() ) {
      if( items_word[item] == word ) {
        return Type.createEnum(Items_types, item);
      }
    }

    throw 'item type not valid (new version?).';
  }

  public static function equal( f_id : Id, s_id : Id ) : Bool {
    if( f_id.host == s_id.host && f_id.first == s_id.first && f_id.second == s_id.second && f_id.third == s_id.third && Type.enumEq(f_id.type, s_id.type) ) {
      return true;
    } else {
      return false;
    }
  }
}
