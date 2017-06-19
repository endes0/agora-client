package beartek.utils;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import org.msgpack.MsgPack;
import haxe.net.Websocket;

class Wtpc {
	var connection : Class = null;
	public var connected : Bool = false;
	public var recived_Bytes : Int = 0;
	public var sent_Bytes : Int = 0;
	public var errors : Int = 0;


	public function new( host : String, ?secure : Bool = true ) {
		connection = Websocket.create(if (secure) "wss://" + host + "/" else "ws://" + host + "/", ["wtp"], false);
		connection.onopen = function() {
				this.connected = true;
				this.on_open();
			}
		connection.onmessageBytes = function ( msg : Bytes ) {
				recived_Bytes += msg.length;
				this.on_msg(MsgPack.decode(msg));
			}
		connection.onerror = function ( msg : String ) {
				errors++;
				this.on_error(msg);
			}
	}	
	
	inline public function make_pet( type : Pet_types, ?data : Dynamic = null ) {
		this.send({type: type, data: data});
	}

	
	private function send( msg : Dynamic ) {
		var to_send : Bytes = MsgPack.encode(msg);
		Sent_Bytes += to_send.length;
		connection.sendBytes(to_send);
	}
	
	public inline function refresh() {
		connection.process();
	}

	
	public dynamic function on_open() {
	}
	
	public dynamic function on_msg( msg : Dynamic ) {
	}
	
	public dynamic function on_error( msg : String ) {
	}
}

enum Pet_types {
		Get(method : String);
		Create(method : String);
		Remove(method : String);
	}
