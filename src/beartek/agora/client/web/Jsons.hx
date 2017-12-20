//Under GNU AGPL v3, see LICENCE
package beartek.agora.client.web;

import org.tamina.i18n.ITranslation;
import org.tamina.i18n.LocalizationManager;

 class Jsons {
   static public var server : {name: String, host: String, secure: Bool};
   static public var slogans : Array<String>;
   public static var translations(default, set) : Array<ITranslation>;

   public static function set_translations( t : Array<ITranslation> ) : Array<ITranslation> {
     LocalizationManager.instance.setTranslations(t);
     return t;
   }
 }
