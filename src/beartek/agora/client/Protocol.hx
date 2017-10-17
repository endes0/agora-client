package beartek.agora.client;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import beartek.agora.types.Types;
import beartek.agora.types.Tid;
import beartek.agora.types.Tpost;
import beartek.agora.types.Tsentence;
import beartek.utils.Wtpc;
import haxe.io.Bytes;
import siphash.SipHash;

class Protocol extends Wtpc {
	var is_wait : Bool = false;
	var wait_time : Int = 0;
	var wait_checks : Int = 0;

	var queque : Any = null;
	var queque_error : Error = null;



	public function new( host : String, ?wait_for_response : Bool = false, ?waiting_time : Int = 3000, ?wainting_checks : Int = 20, secure : Bool = true, ?connection_creator : String->Dynamic, ?handler_register : Void->Void ) {
		is_wait = wait_for_response;
		wait_time = waiting_time;
		wait_checks = wainting_checks;
		super(host, secure, connection_creator, handler_register);
	}

	override function on_msg( msg : {id: String, type: String, data: Dynamic} ) {
		if (is_wait){
			this.queque = msg;
		} else {
			if (msg.type == 'Error') {
				this.on_response(msg);
			} else {
				this.on_response(msg);
			}

		}
	}

	private function wait_response( ?i = 0) : Dynamic {
		if (is_wait) {
			if( i < wait_checks ) {
				if (queque != null || queque_error !=null) {
				  if( i == 0 ) {
						var q : Dynamic = queque;

						queque = null;

						if( q.type == 'error' ) {
							queque_error = q.data;
							return null;
						} else {
							return q.data;
						}
				  } else {
				  	return null;
				  }
				} else {
					this.refresh();
					this.wait(function() : Void {
						this.wait_response(i++);
					});

					return this.queque;
				}
			} else {
				var err : Error = {type: 0, msg: 'Time out'};
				this.queque == err;
				return null;
			}
		} else {
			return null;
		}
	}

	private inline function wait(handler:Void->Void):Void {
		haxe.Timer.delay(handler, Std.int(wait_time/wait_checks));
	}

	private function generate_loginkey( username : String, password : String ) : haxe.Int64 {
		if( password.length > 59 ) {
			throw 'password too long.';
		}

		var sh = new siphash.SipHash();

		var pass : haxe.io.Int32Array = new haxe.io.Int32Array(4);
		for( pos in 0...password.length ) {
			var i : Int = Math.floor(pos/15);
			pass[i] = ((pass[i] << 2) + password.charCodeAt(pos));
		}
		return sh.reset(pass).fast(Bytes.ofString(username));
	}


	public function get_server_info(?con_id : String) : Null<Server_info> {
		this.make_pet(con_id, Get('server_info'));
		return wait_response();
	}

	public function get_token(?con_id : String) : Null<Bytes> {
		this.make_pet(con_id, Get('token'));
		return wait_response();
	}

	public function auth( privkey : haxe.io.Bytes, token : Bytes, ?con_id : String ) : Null<Bool> {
		var key : haxe.io.Int32Array = haxe.io.Int32Array.fromBytes(privkey);
		var sh = new siphash.SipHash();
		this.make_pet( con_id, Get('auth'), sh.reset(key).fast(token));
		return wait_response();
	}

	public function create_privkey(?con_id : String) : Null<haxe.io.Int32Array> {
		this.make_pet(con_id, Create('privkey'));
		return wait_response();
	}

	public function create_privkey_with_login( username : String, password : String, ?con_id : String ) : Null<haxe.io.Int32Array> {
		var loginkey : haxe.Int64 = this.generate_loginkey(username, password);

		this.make_pet(con_id, Create('privkey_with_login'), loginkey);
		return wait_response();
	}

	public function remove_devicekey( key : haxe.Int64, ?con_id : String ) : Null<Bool> {
		this.make_pet(con_id, Remove('devicekey'), key);
		return wait_response();
	}

	public function get_devicekeys(?con_id : String) : Null<Array<haxe.Int64>> {
		this.make_pet(con_id, Get('devicekeys'));
		return wait_response();
	}

	public function get_post_info( ?con_id : String, id : Id ) : Null<Post_info> {
		this.make_pet(con_id, Get('post_info'), new Tid(id));
		return wait_response();
	}

	public function get_post( id : Id, ?get_info : Bool = false, ?con_id : String ) : Null<Post> {
		if (get_info) {
			this.make_pet(con_id, Get('full_post'), new Tid(id));
		} else {
			this.make_pet(con_id, Get('post'), new Tid(id));
		}

		return wait_response();
	}

	public function create_post( post : Post, ?con_id : String ) : Null<Id> {
		var post = new Tpost(post);

		if( post.is_draft() ) {
			this.make_pet(con_id, Create('post'), post);
		} else {
			var id : Id = post.get().info.id;
			post.to_draft();
			this.make_pet(con_id, Create('edit_post'), {id: id, data: post});
		}
		return wait_response();
	}

	public function remove_post( id : Id, ?con_id : String ) : Null<Bool> {
		this.make_pet(con_id, Remove('post'), new Tid(id));
		return wait_response();
	}

	public function report( report : Report, ?con_id : String ) : Null<Bool> {
		this.make_pet(con_id, Create('report'), report);
		return wait_response();
	}

	public function get_sentence( id : Id, ?con_id : String ) : Null<Sentence> {
		this.make_pet(con_id, Get('sentence'), new Tid(id));
		return wait_response();
	}

	public function create_sentence( sentence : Sentence, ?con_id : String ) : Null<Id> {
		var sentence = new Tsentence(sentence);

		if( sentence.is_draft() ) {
			this.make_pet(con_id, Create('sentence'), sentence);
		} else {
			var id : Id = sentence.get().id;
			sentence.to_draft();
			this.make_pet(con_id, Create('edit_sentence'), {id: id, data: sentence});
		}
		return wait_response();
	}

	public function remove_sentence( id : Id, ?con_id : String ) : Null<Bool> {
		this.make_pet(con_id, Remove('sentence'), new Tid(id));
		return wait_response();
	}

	public function get_user_info( id : Id, ?con_id : String ) : Null<User_info> {
		this.make_pet(con_id, Get('user_info'), id);
		return wait_response();
	}

	public function get_user_profile( id : Id, ?get_info : Bool = false, ?con_id : String ) : Null<User_profile> {
		if (get_info) {
			this.make_pet(con_id, Get('full_user_profile'), id);
		} else {
			this.make_pet(con_id, Get('user_profile'), id);
		}

		return wait_response();
	}

	public function create_user( profile : User_profile, ?con_id : String ) : Null<Id> {
		this.make_pet(con_id, Create('user_profile'), profile);
		return wait_response();
	}

	public function register_user( data : Dynamic, ?con_id : String ) : Null<Id> {
		this.make_pet(con_id, Create('user_registration'), data);
		return wait_response();
	}

	//get the list of trending concepts by ids.
	public function get_tc(?con_id : String) : Null<Array<Id>> {
		this.make_pet(con_id, Get('trending_concepts'));
		return wait_response();
	}

	//get the list of trending topics by ids
	public function get_tt(?con_id : String) : Null<Array<Id>> {
		this.make_pet(con_id, Get('trending_concepts'));
		return wait_response();
	}

	public function search( search : Search, ?con_id : String ) : Null<Search_results> {
		if (Reflect.fields(search).length == 0) {
			this.log('No search paramater, returning random result.');
			this.make_pet(con_id, Get('search'));
		} else {
			this.make_pet(con_id, Get('search'), search);
		}
		return wait_response();
	}

	public function regex_search( patern : String, ?con_id : String ) : Null<Search_results> {
		this.make_pet(con_id, Get('regex_search'), patern);
		return wait_response();
	}

	public function get_default_config(?con_id : String) : Null<Config> {
		this.make_pet(con_id, Get('default_config'));
		return wait_response();
	}

	public function get_my_config(?con_id : String) : Null<Config> {
		this.make_pet(con_id, Get('my_config'));
		return wait_response();
	}

	public function save_my_config( config : Config, ?con_id : String ) {
		this.make_pet(con_id, Create('my_config'), config);
		return wait_response();
	}

	//get reistration form.
	public function get_reg_form(?con_id : String) : Null<Dynamic> {
		this.make_pet(con_id, Get('registration_form'));
		return wait_response();
	}

	//get report form.
	public function get_rep_form(?con_id : String) : Null<Dynamic> {
		this.make_pet(con_id, Get('report_form'));
		return wait_response();
	}

	public function get_error() : Null<Error> {
		if (queque_error != null) {
			var error : Error = queque_error;
			queque_error = null;

			return error;
		} else {
			return null;
		}
	}

	public dynamic function on_response( data : {id: String, type: String, data: Dynamic} ) {
		//
	}
}
