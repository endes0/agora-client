package beartek.utils.iso_codes;
import beartek.utils.iso_codes.Iso_macro;

class Country_db {
  var db : Array<Country> = null;

  public function new() {
    var data : Dynamic = null;
    #if builtin
      data = Iso_macro.get_json('iso_3166-1');
    #else
      #if sys
        if( sys.FileSystem.exists('/usr/share/iso-codes/iso_3166-1.json') ) {
          data = haxe.Json.parse(sys.io.File.getContent('/usr/share/iso-codes/iso_3166-1.json'));
        } else if( sys.FileSystem.exists('data/iso-codes/iso_3166-1.json') ) {
          data = haxe.Json.parse(sys.io.File.getContent('data/iso-codes/iso_3166-1.json'));
        } else {
          var raw_data : String = haxe.Http.requestUrl('https://anonscm.debian.org/cgit/pkg-isocodes/iso-codes.git/plain/data/iso_3166-1.json');
          if( raw_data == null ) {
            throw 'Cant find iso country codes database.';
          } else {
            data = haxe.Json.parse(raw_data);
          }
        }
      #else
        var raw_data : String = haxe.Http.requestUrl('https://anonscm.debian.org/cgit/pkg-isocodes/iso-codes.git/plain/data/iso_3166-1.json');
        if( raw_data == null ) {
          throw 'Cant find iso country codes database.';
        } else {
          data = haxe.Json.parse(raw_data);
        }
      #end
    #end

    this.db = Reflect.field(data, '3166-1');
  }

  public function get_by_code( code : String ) : Country {
    for( country in db ) {
      if( country.alpha_3 == code ) {
        return country;
      }
    }

    throw 'Country not found';
  }

  public function get_by_name( name : String ) : Country {
    for( country in db ) {
      if( country.name == name ) {
        return country;
      }
    }

    throw 'Country not found';
  }

  public function get_by_numeric( n : Int ) : Country {
    for( country in db ) {
      if( country.numeric == n ) {
        return country;
      }
    }

    throw 'Country not found';
  }

  public function get_list() : Array<Country> {
    return db;
  }

}

typedef Country = {
  var name : String;
  var alpha_2 : String;
  var alpha_3 : String;
  var numeric : Int;
  var official_name : String;

}

abstract Country_code(String) {
  public inline function new( code : String ) {
    var checker = new Country_db();
    if (checker.get_by_code(code) != null) {
      this = code;
    } else {
      throw 'Country code doesnt exist in db.';
    }
  }

  public inline function get_country() : Country {
    var db = new Country_db();
    return db.get_by_code(this);
  }
}
