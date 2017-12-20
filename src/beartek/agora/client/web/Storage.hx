//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web;


class Storage {

  public static inline function save( key : String, data : Dynamic ) : Void {
    js.Browser.getLocalStorage().setItem(key, haxe.Serializer.run(data));
  }

  public static inline function get( key : String ) : Dynamic {
    if( js.Browser.getLocalStorage().getItem(key) != null ) {
      return haxe.Unserializer.run(js.Browser.getLocalStorage().getItem(key));
    } else {
      return null;
    }
  }

  public static inline function remove( key : String ) : Void {
    js.Browser.getLocalStorage().removeItem(key);
  }

}
