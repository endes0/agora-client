package beartek.agora.client;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import htmlparser.HtmlDocument;
import beartek.utils.Country_codes;

typedef Server_info = {
	var name : String;
	var description : String;
	var host : String;
	var version : Version;
	var country : Country;
	var owner : User_info;
	var privacy_policy : HtmlDocument;
	var rules : HtmlDocument;
	var server_ver : Version;
	var protocol_ver : Version;
	}
	
typedef Post_info =  {
	var title : String;
	var subtitle : String;
	var overview : String;
	@optional var id : Id;
	var author : User_info;
	var emoticons_votes : Map<String8, Int>;
	var publish_date : Date;
	var edit_date : Date;
	}
	
typedef Post = {
	var info : Post_info;
	var content : HtmlDocument;
	var tags : Array<String>;
	@optional var concept : String;
	@optional var topic : String;

	var positive_comments : Array<Post_info>;
	var semi_positive_comments : Array<Post_info>;
	var semi_negative_comments : Array<Post_info>;
	var negative_comments : Array<Post_info>;
	}
	
typedef Sentence = {
	var id : Id;
	var sentence : String;
	var author : User_info;
	var publish_date : Date;
	var edit_date : Date;
	}
	
typedef User_info = {
	var username : String;
	var first_name : String;
	var second_name : String;
	var pinned_sentence : Sentence;
	var image_src : String;
	var id : Id;
	var join_date : Date;
	var last_login : Date;
	}
	
typedef Concept = {
	//TODO: terminar
	}
	
typedef User_profile = {
	//TODO: terminar
	}
	
typedef Report = {
	//TODO: terminar
	}

typedef Search = {
	@optional var tags : Map<String, Bool>;
	@optional var type : Array<Items_list>;
	@optional var starts_with : String;
	@optional var contain : String;
	@optional var dont_contain : String;
	}
	
typedef Search_results = {
	var posts : Array<Post_info>;
	var sentences : Array<Sentence>;
	var users : Array<User_info>;
	}

	
enum Items_types {
	Post_item;
	Sentence_item;
	User_item;
	}

	

typedef Form_template = {
	//TODO: terminar
	}
	
typedef Config = {
	//TODO: terminar
	}
	
typedef Id = {
	var host : String;
	var first : String;
	var seconfd : String;
	var third : String;
	}

typedef Version = {
	var major : Int;
	var minor : Int;
	var patch : Int;
	@optional var commit : String;
	}
typedef Error = {
	var type : Int;
	var msg : String;
	}

