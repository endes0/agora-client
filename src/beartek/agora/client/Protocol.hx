package beartek.agora.client;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import beartek.agora.client.Types;
import beartek.agora.utils.Wtpc;


class Protocol extends Wtpc {
	var wait : Bool = false;
	var wait_time : Int = 0;

	var queque : Any = null;
	var queque_error : Error = null;



	public function new( host : String, ?wait_for_response : Bool = false, ?waiting_time : Int = 3000 ) {
		wait = wait_for_response;
		wait_time = waiting_time;
		super(host);
	}
	
	override private function on_msg( msg : Dynamic ) {
		if (wait){
			this.queque = msg;
		} else {
			if (Std.is(this.queque, Error) | queque == null) {
				
			} else {
				this.on_response(msg);
			}

		}
	}
	
	override private function on_error( msg : String ) {
		if (wait){
			this.queque = msg;
		} else {
			
		}
	}
	
	private function wait_response() : Any {
		if (wait) {
		#if sys
			Sys.sleep(Std.int(wait_time));
			this.refresh();
			return this.process_msg();
		#else
			//TODO: terminar
		#end	
		} else {
			return null;
		}

	}
	
	private function process_msg() : Any {
		if (Std.is(this.queque, Error) | queque == null) {
			return null;
		} else {
			return queque;
			queque = null;
		}
	}

	
	public function get_server_info() : Null<Server_info> {
		this.make_pet(Get('server_info'));
		return wait_response();
	}

	
	public function get_post_info( id : Id ) : Null<Post_info> {
		this.make_pet(Get('post_info'), id);
		return wait_response();
	}
	
	public function get_post( id : Id, ?get_info : Bool = false ) : Null<Post> {
		if (get_info) {
			this.make_pet(Get('full_post'), id);
		} else {
			this.make_pet(Get('post'), id);
		}

		return wait_response();
	}
	
	public function create_post( post : Post ) : Null<Id> {
		this.make_pet(Create('post'), post);
		return wait_response();
	}
	
	public function remove_post( id : Id ) : Null<Bool> {
		this.make_pet(Get('post_info'), id);
		return wait_response();
	}
	
	public function report( report : Report ) : Null<Bool> {
		this.make_pet(Create('report'), report);
		return wait_response();
	}
	
	public function get_sentence( id : Id ) : Null<Sentence> {
		this.make_pet(Get('sentence'), id);
		return wait_response();
	}
	
	public function create_sentence( sentence : Sentence ) : Null<Id> {
		this.make_pet(Create('sentence'), sentence);
		return wait_response();
	}
	
	public function remove_sentence( id : Id ) : Null<Bool> {
		this.make_pet(Remove('sentence'), id);
		return wait_response();
	}
	
	public function get_user_info( id : Id ) : Null<User_info> {
		this.make_pet(Get('user_info'), id);
		return wait_response();
	}
	
	public function get_user_profile( id : Id, ?get_info : Bool = false ) : Null<User_profile> {
		if (get_info) {
			this.make_pet(Get('full_user_profile'), id);
		} else {
			this.make_pet(Get('user_profile'), id);
		}

		return wait_response();
	}
	
	public function create_user( profile : User_profile ) : Null<Id> {
		this.make_pet(Create('user_profile'), profile);
		return wait_response();
	}
	
	public function register_user( data : Form_data ) : Null<Id> {
		this.make_pet(Create('user_registration'), data);
		return wait_response();
	}
	
	//get the list of trending concepts by ids.
	public function get_tc() : Null<Array<Id>> {
		this.make_pet(Get('trending_concepts'));
		return wait_response();
	}
	
	//get the list of trending topics by ids
	public function get_tt() : Null<Array<Id>> {
		this.make_pet(Get('trending_concepts'));
		return wait_response();
	}
	
	public function search( search : Search ) : Null<Search_results> {
		if (search.tags == null && search.type == null && search.starts_with == null && search.contain == null && search.dont_contain == null ) {
			throw 'Agora protocol: search parameter excepted.';
		}

		this.make_pet(Get('search'), search);
		return wait_response();
	}

	public function regex_search( patern : String ) : Null<Search_results> {
		this.make_pet(Get('regex_search'), patern);
		return wait_response();
	}
	
	public function get_default_config() : Null<Config> {
		this.make_pet(Get('default_config'));
		return wait_response();
	}
	
	public function get_my_config() : Null<Config> {
		this.make_pet(Get('my_config'));
		return wait_response();
	}
	
	public function save_my_config( config : Config ) {
		this.make_pet(Create('my_config'), config);
		return wait_response();
	}
	
	//get reistration form.
	public function get_reg_form() : Null<Form_template> {
		this.make_pet(Get('registration_form'));
		return wait_response();
	}
	
	//get report form.
	public function get_rep_form() : Null<Form_template> {
		this.make_pet(Get('report_form'));
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
	
	public dynamic function on_response() {
		//
	}
}