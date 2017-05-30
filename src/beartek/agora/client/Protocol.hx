package beartek.agora.client;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
class Protocol {
	public function new( ?wait_for_response : Bool = false, ?waiting_time : Int = 3000 ) {
		
	}
	
	public function get_server_info() : Null<Server_info> {
		//
	}

	
	public function get_post_info( id : Id ) : Null<Post_info> {
		//
	}
	
	public function get_post( id : Id, ?get_info : Bool = false ) : Null<Post> {
		//
	}
	
	public function create_post( post : Post ) : Null<Id> {
		//
	}
	
	public function remove_post( id : Id ) : Null<Bool> {
		//
	}
	
	public function report_post( report : Report ) : Null<Bool> {
		//
	}
	
	public function get_sentence( id : Id ) : Null<Sentence> {
		//
	}
	
	public function create_sentence( sentence : Sentence ) : Null<Id> {
		//
	}
	
	public function remove_sentence( id : Id ) : Null<Bool> {
		//
	}
	
	public function report_sentence( report : Report ) : Null<Bool> {
		//
	}
	
	public function get_user_info( id : Id ) : Null<User_info> {
		//
	}
	
	public function get_user_profile( id : Id, ?get_info : Bool = false ) : Null<User_profile> {
		//
	}
	
	public function create_user( data : Form_data ) : Null<Id> {
		//
	}

	public function get_concept( id : String ) : Null<Concept> {
		//
	}
	
	//get the list of trending topics by ids.
	public function get_tc() : Null<Array<String>> {
		//
	}
	
	//get the list of trending concepts by ids
	public function get_tt() : Null<Array<String>> {
		//
	}
	
	public function search( tags : Map<String, Bool>, type : Array<Items_list>, starts_with : String, contain : String, dont_contain : String ) : Null<Array<Items_types>> {
		//
	}
	
	inline public function basic_search( contain : String ) : Null<Array<Items_types>> {
		//
	}

	public function regex_search( patern : String ) : Null<Array<Items_types>> {
		//
	}
	
	public function get_default_config() : Null<Config> {
		//
	}
	
	public function get_my_config() : Null<Config> {
		//
	}
	
	public function save_my_config( config : Config ) {
		//
	}
	
	public function get_reg_form() : Null<Form_template> {
		//
	}
	
	public function get_rep_form() : Null<Form_template> {
		//
	}
	
	public function get_error() : Error {
		//
	}
	
	public dynamic function on_msg ( msg : Dynamic ) {
		//
	}

	public dynamic function on_error ( error : Error ) {
		//
	}
}