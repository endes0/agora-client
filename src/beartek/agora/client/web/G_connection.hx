package beartek.agora.client.web;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import haxe.io.Bytes;
import beartek.agora.client.Protocol;
#if dummy_server
import beartek.agora.client.test.Dummy_server;
#end

class G_connection {
  static public var token : Bytes;

  static var connection : Protocol;
  static var handlers : Map<String, Map<String, Array<Dynamic -> Void>>> = new Map();
  static var open_handlers : Array<Void -> Void> = [];
  static var close_handlers : Array<Void -> Void> = [];

  static public function open_connection( host : String, async : Bool = false, secure : Bool = true ) : Void {
    if( secure == false ) {
      trace( 'Insecure connection' );
      //TODO: notificar conexion insegura
    }

    #if dummy_server
    connection = new Protocol('dummy-host', function( host : String ) : Dynamic {
      return new Dummy_server();
    });
    #else
    connection = new Protocol(host, async, secure);
    #end

    connection.on_response = function ( data : {id: String, type: String, data: Dynamic} ) : Void {
      if( data.type == 'token' ) {
        token = data.data;
        for( handler in open_handlers ) {
          handler();
        }
      } else {
        var con_id : String = if(data.id == null) '' else data.id;
        if( handlers[con_id] != null &&  handlers[con_id][data.type] != null ) {
          for( handler in handlers[con_id][data.type] ) {
            handler(data.data);
          }
        }
      }

    };
    connection.log = function ( msg : String ) : Void {
       trace( msg );
    };

    connection.on_open = function () : Void {
       connection.get_token();
    };

    connection.on_close = function () : Void {
      for( handler in close_handlers ) {
        handler();
      }

      handlers = new Map();
      open_handlers = [];
      close_handlers = [];
      connection = null;
    };
  }

  static public function close_connection() : Void {
    connection.close();
  }

  static public function g() : Null<Dynamic> {
    if( connection != null ) {
      return connection;
    } else {
      throw 'Connection isnt open.';
      return null;
    }
  }

  static public function add_response_handler( on_type : String, handler : Dynamic -> Void, ?con_id : String = '' ) : Void {
    create_handlers_map(con_id, on_type);
    handlers[con_id][on_type].push(handler);
  }

  static public function add_open_handler( handler : Void -> Void ) : Void {
    open_handlers.push(handler);
  }

  static public function add_close_handler( handler : Void -> Void ) : Void {
    close_handlers.push(handler);
  }

  static inline public function exist() : Bool {
    if( connection != null ) {
      return true;
    } else {
      return false;
    }
  }

  static private function create_handlers_map(con_id, on_type) : Void {
    if(handlers[con_id] == null) handlers[con_id] = new Map();
    if(handlers[con_id][on_type] == null) handlers[con_id][on_type] = [];
  }

}
