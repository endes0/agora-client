package beartek.agora.client.test;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import beartek.agora.types.Types;
import beartek.agora.types.Tid;
import beartek.agora.client.Protocol;
import beartek.utils.Wtpc;
import beartek.utils.Wtp_types;
import haxe.io.Bytes;
import haxe.Serializer;
import haxe.Unserializer;
import datetime.DateTime;

@:keep
class Dummy_server {
	var is_c_opened : Bool = false;

	var publish_date : DateTime = DateTime.make(2022, 7, 22, 6, 30, 0);
	var author : User_info = {
		username: 'Lorem',
		first_name: 'mundo',
		second_name: 'hola',
		pinned_sentence: null,
		image_src: 'https://hi.com',
		id: {host: 'dummy-host', type: User_item, first: 'E4', second: 'G4', third: 'C4'},
		join_date: DateTime.make(2017, 5, 13, 0, 20, 0),
		last_login: DateTime.make(2090, 0, 1, 0, 0, 0)};

	var r_post : Post = null;
	var r_post_id : Id = {host: 'dummy-host', type: Post_item, first: 'E#', second: 'E5', third: '00'};

	var r_sentence : Sentence = null;
	var r_sentence_id : Id = {host: 'dummy-host', type: Sentence_item, first: 'E#', second: 'E5', third: '00'};

	public function new( ) {
		log('Connection opened.');
		haxe.Timer.delay(this.process, 30);
	}

	public function process() {
		log('Refresh called.');
		if( is_c_opened == false ) {
			is_c_opened = true;
			this.onopen();
		}
	}

	public function close() : Void {
		this.onclose();
	}

	public function sendBytes( msg : Bytes ) {
		var msg : {id: String, type: Pet_types, data: Dynamic} = Unserializer.run(msg.toString());
		log('Msg recived: ' + msg);

		switch (msg.type) {
			case Get(d):
				log('Get recived.');
				this.dummy_get(msg.id, d, msg.data);
			case Create(d):
				log('Create recived.');
				this.dummy_create(msg.id, d, msg.data);
			case Remove(d):
				log('Remove recived.');
				this.dummy_remove(msg.id, d, msg.data);
			case _:
				throw 'Unknow msg type recived.';
		}
	}


	private function dummy_get( conn_id : String, method : String, data : Dynamic ) {
		if( method == 'full_post' ) {
			var recived_id : Id = data;

			log( 'cheking id...' );
			if( Tid.equal(r_post_id, recived_id) ) {
				log('cheking if exist...');
				if( r_post != null ) {
					log( 'sending post.' );
					this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'full_post', data: r_post})));
				} else {
					log( 'sending error.' );
					this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'error', data: {type: 10, msg: 'Post doesnt exist.'}})));
				}
			} else {
				throw 'id mismatching.';
			}
		} else if( method == 'sentence' ) {
			var recived_id : Id = data;

			log( 'cheking id...' );
			if( Tid.equal(r_sentence_id, recived_id) ) {
				log('cheking if exist...');
				if( r_sentence != null ) {
					log( 'sending sentence.' );
					this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'sentence', data: r_sentence})));
				} else {
					log( 'sending error.' );
					this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'error', data: {type: 11, msg: 'Sentence doesnt exist.'}})));
				}
			} else {
				throw 'id mismatching.';
			}
		} else if( method == 'token' ) {
			log( 'Sending token.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'token', data: Bytes.ofString('Dummy-token')})));
		} else if( method == 'auth' ) {
			log('Auth public key: ' + data);
			log( 'Sending auth complete.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'auth', data: true})));
		} else if( method == 'search' ) {
			log('Returning random data.');

			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'search_result', data: {posts: this.generate_post_infos()}})));
		} else {
			throw('Not yet implemented.');
		}
	}

	private function dummy_create( conn_id : String, method : String, data : Dynamic ) {
		if( method == 'post' ) {
			this.r_post = data;
			r_post.info.author = this.author;
			r_post.info.publish_date = publish_date;
			r_post.info.id = r_post_id;
			r_post.info.emoji_votes = new Map();
			log( 'Post saved, sending id.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'id', data: r_post_id})));
		} else if( method == 'sentence' ) {
			this.r_sentence = data;
			r_sentence.id = r_sentence_id;
			r_sentence.author = this.author;
			r_sentence.publish_date = this.publish_date;
			log( 'Sentence saved, sending id.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'id', data: r_sentence_id})));
		} else if( method == 'privkey_with_login' ) {
			log('Loginkey: ' + data);
			log('Sending privkey.');
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'privkey', data: [0x454f8e, 0x435adf, 0x84aa32, 0x5832df]})));
		} else {
			throw('Not yet implemented.');
		}
	}

	private function dummy_remove( conn_id : String, method : String, data : Dynamic ) {
		//TODO: comprobar id.
		if( method == 'post' ) {
			if(Tid.equal(r_post_id, data)) this.r_post = null else throw 'Invalid id';
			log( 'Post removed.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'removed_post', data: true})));
		} else if( method == 'sentence' ) {
			if(Tid.equal(r_sentence_id, data)) this.r_sentence = null else throw 'Invalid id';
			log( 'Sentence remove.' );
			this.onmessageBytes(Bytes.ofString(Serializer.run({id: conn_id, type: 'removed_sentence', data: true})));
		} else {
			throw('Not yet implemented.');
		}
	}

	private function generate_post_infos() : Array<Post_info> {
		var posts : Array<Post_info> = [];
		if(r_post != null) posts.push(r_post.info);

		for( num in 0...50 ) {
			var post_info : Post_info = {title: 'Num ' + num, subtitle: 'Lorem is ' + num, overview: 'Large gfdgdfgfdjgjkdfghfdkjgdfkjgfjkdgjkdfkjgdfhgkjdfghdfghdfkgjhdf'};
			posts.push(post_info);
		}

		return posts;
	}

	public dynamic function onopen() {}

	public dynamic function onclose() {}

	public dynamic function onmessageBytes( msg : Bytes ) {}

	public dynamic function onerror( msg : String ) {}

	public dynamic function log( msg : String ) {
		trace( msg );
	}

}
