package beartek.utils;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import haxe.Serializer;
import haxe.Unserializer;
import haxe.net.WebSocket;
import haxe.io.Bytes;

class Wtpc {
  var connection : Dynamic = null;
	public var connected : Bool = false;
	public var host : String;
	public var secure : Bool;


	public var recived_bytes : Int = 0;
	public var sent_bytes : Int = 0;
	public var errors : Int = 0;


	public function new( host : String, ?secure : Bool = true, ?connection_creator : String->Dynamic, ?handler_register : Void->Void ) {
		this.secure = secure;
		this.host = host;
		if( connection_creator != null ) {
		  connection = connection_creator(host);
      if( Type.getInstanceFields(Type.getClass(connection)).indexOf('sendBytes') == -1 ) {
        throw 'Connection handler doesnt have function sendBytes.';
      }
		} else {
      connection = this.open_connection(host);
		}
    if( handler_register != null ) {
      handler_register();
    } else {
      this.register_handlers();
    }
	}

	inline public function make_pet( id : String = null, type : Pet_types, ?data : Dynamic = null ) {
		this.send({id: id, type: type, data: data});
	}


	private function send( msg : Dynamic ) {
		var to_send : Bytes = Bytes.ofString(Serializer.run(msg));
		sent_bytes += to_send.length;
		connection.sendBytes(to_send);
	}

	public function refresh() {
		connection.process();
	}

  public function close() {
    connection.close();
  }

	private function open_connection( host : String ) : Dynamic {
		return WebSocket.create(if (secure) "wss://" + host + "/" else "ws://" + host + "/", ["wtp"], false);
	}

  private function register_handlers() : Void {
    connection.onopen = function() {
      this.connected = true;
      this.on_open();
    }
    connection.onclose = function() {
      this.connected = false;
      this.on_close();
    }
    connection.onmessageBytes = function ( msg : Bytes ) {
      recived_bytes += msg.length;
      var data : {id: String, type: String, data: Dynamic} = Unserializer.run(msg.toString());

      if( data.type == 'error' ) {
        errors++;
      }

      this.on_msg(data);
    }
    connection.onerror = function ( msg : String ) {
      errors++;
      this.on_msg({id: null, type: 'error', data: {type: 1, msg: msg}});
    }


      connection.log = function( msg : String ) {
        this.log( '[Connection]' + msg);
      }
  }

  public dynamic function log( msg : String ) {
	}

	public dynamic function on_open() {
	}

  public dynamic function on_close() {
	}

	public dynamic function on_msg( msg : {id: String, type: String, data: Dynamic} ) {
	}
}

enum Pet_types {
		Get(method : String);
		Create(method : String);
		Remove(method : String);
	}
