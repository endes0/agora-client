package beartek.agora.types;

import beartek.utils.iso_codes.Country_db;
import htmlparser.HtmlDocument;
import datetime.DateTime;

typedef Concept = {
	//TODO: terminar
}

typedef Server_info = {
	var name : String;
	var description : String;
	var host : String;
	var version : Version;
	var country : Country_code;
	var owner : User_info;
	var privacy_policy : HtmlDocument;
	var rules : HtmlDocument;
	var server_ver : Version;
	var protocol_ver : Version;
}

typedef Sentence = {
	@:optional var id : Id;
	var sentence : String;
	@:optional var author : User_info;
	@:optional var publish_date : DateTime;
	@:optional var edit_date : DateTime;
}

typedef Search = {
	@:optional var tags : Map<String, Bool>;
	@:optional var topic : String;
	@:optional var event : String;
	@:optional var type : Array<Items_types>;
	@:optional var starts_with : String;
	@:optional var contain : String;
	@:optional var dont_contain : String;
	@:optional var starts_by : Id;
	@:optional var order_by : Order_types;
}

typedef Search_results = {
	var posts : Array<Post_info>;
	var sentences : Array<Sentence>;
	var users : Array<User_info>;
}


typedef Report = {
	//TODO: terminar
}

typedef Post_info =  {
	var title : String;
	var subtitle : String;
	var overview : String;
	@:optional var id : Id;
	@:optional var author : User_info;
	@:optional var emoji_votes : Map<String, Int>;
	@:optional var publish_date : DateTime;
	@:optional var edit_date : DateTime;
}

typedef Post = {
	var info : Post_info;
	var content : HtmlDocument;
	var tags : Array<String>;
	@:optional var concepts : Map<String, Critic_level>;
	@:optional var topics : String;
	@:optional var comments : Array<Post_info>;
}

typedef User_info = {
	var username : String;
	var first_name : String;
	var second_name : String;
	@:optional var pinned_sentence : Id;
	@:optional var image_src : String;
	var id : Id;
	var join_date : DateTime;
	var last_login : DateTime;
}

typedef User_profile = {
	//TODO: terminar
}


typedef Config = {
	//TODO: terminar
}

typedef Id = {
	var host : String;
	var type : Items_types;
	var first : String;
	var second : String;
	var third : String;
}

typedef Version = {
	var major : Int;
	var minor : Int;
	var patch : Int;
	@:optional var commit : String;
}

typedef Error = {
	var type : Int;
	var msg : String;
}

enum Order_types {
	Recent_date;
	Older_date;
	Most_popular;
	Least_popular;
	Most_popular_over_time;
	Least_popular_over_time;
}

enum Items_types {
	Post_item;
	Sentence_item;
	User_item;
}

enum Critic_level {
		Very_good;
		Good;
		Bad;
		Very_bad;
}
