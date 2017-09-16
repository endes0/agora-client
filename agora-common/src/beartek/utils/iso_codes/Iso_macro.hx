package beartek.utils.iso_codes;

class Iso_macro{

  macro public static function name( json : haxe.macro.Expr.ExprOf<String> ) : haxe.macro.Expr.ExprOf<Dynamic> {
    #if !display
    if( sys.FileSystem.exists('/usr/share/iso-codes/' + json + '.json') ) {
      return macro $v{haxe.Json.parse(sys.io.File.getContent('/usr/share/iso-codes' + json + '.json'))};
    } else if( sys.FileSystem.exists('../data/iso-codes/' + json + '.json') ) {
      return macro $v{haxe.Json.parse(sys.io.File.getContent('../data/iso-codes/' + json + '.json'))};
    } else {
      var data : String = haxe.Http.requestUrl('https://anonscm.debian.org/cgit/pkg-isocodes/iso-codes.git/plain/data/' + json + '.json');
      if( data == null ) {
        throw 'Cant find iso country codes database.';
      } else {
        return macro $v{haxe.Json.parse(data)};
      }
    }
   #else
   var data:Dynamic = null;
   return macro $v{data};
   #end
  }

}
