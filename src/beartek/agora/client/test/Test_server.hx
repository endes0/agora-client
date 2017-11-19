package beartek.agora.client.test;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import beartek.agora.client.test.Dummy_server;
import beartek.agora.types.Types;
import beartek.agora.types.Tpost;
import beartek.agora.types.Tsentence;
import beartek.agora.types.Tuser_info;
import htmlparser.HtmlDocument;
import datetime.DateTime;

class Test_server extends mohxa.Mohxa {
	var connection : Protocol;
	var connection_async : Protocol;
	var recived : Bool = false;
	var stamp_waiting : Float = 0;

	var expected_response : String;
	var expected_item : Items_types;

	var privkey : haxe.io.Int32Array = new haxe.io.Int32Array(4);

	var post_id : Id;
	var post_id_nd : Id;
	var sentence_id : Id;
	var sentence_id_nd : Id;

	var post_data : Post = {
		info: {
			title: 'Hola',
			subtitle: 'mundo',
			overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum nisl enim, vitae pharetra ligula tristique commodo. Proin risus sapien, faucibus ac enim quis, scelerisque tincidunt arcu. Cras faucibus et neque id sagittis. Nullam rutrum mauris id scelerisque lacinia. Pellentesque in felis dignissim, posuere arcu ac, feugiat ipsum. Vivamus auctor fringilla lacus, ut efficitur dolor imperdiet a. Duis gravida, est imperdiet efficitur bibendum, felis ante tristique quam, vel malesuada elit arcu porttitor quam. Nullam non laoreet lacus.'},
		content: new HtmlDocument(''),
		tags: ['Lorem', 'ipsum']};
	var sentence : Sentence = {
		sentence: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'};



	public function new( host : String ) {
		super();
		describe('Probando protocolo.', function(){
			after(function() {
				log('Comporbando estadisticas.');

				//assertTrue(connection.recived_bytes > 1);
				//assertTrue(connection_async.recived_bytes > 1);
				trace('Bytes recibidos por async: ' + connection_async.recived_bytes + '. Bytes recibidos: ' + connection.recived_bytes);

				//assertTrue(connection.sent_bytes > 1);
				//assertTrue(connection_async.sent_bytes > 1);
				trace('Bytes enviados por async: ' + connection_async.sent_bytes + '. Bytes enviados: ' + connection.sent_bytes);

				//assertTrue(connection.errors < 1);
				//assertTrue(connection_async.errors < 1);
				trace('Errores por async: ' + connection_async.errors + '. Errores: ' + connection.errors + '\n');
			});

			it('Abrir conexion', function (){
				this.open_connection( host );
				var i : Int = 0;
				var stamp : Float = haxe.Timer.stamp();
				while( connection.connected != true && i < 1000000 ) {
					i++;
					Sys.sleep(0.1);
					connection.refresh();
					connection_async.refresh();
				}
				log( 'Waited for server ' + i + ' ticks, ' + (haxe.Timer.stamp() - stamp)*1000 + ' ms' );

				equal(connection.connected, true);
				equal(connection_async.connected, true);
			});

			it('Registrar handler', function() {
				connection.on_response = function ( data : {type: String, data: Dynamic}) {
					this.log('Respuesta recibida.');
					recived = true;
					log('Waited for response ' + (haxe.Timer.stamp() - this.stamp_waiting)*1000 + ' ms');
					if (data.type == 'post_id' && data.type == expected_response) {
						//TODO: chequear que el tipo de elemento es correcto
						var id : Id = data.data;
						check_id(id);
						post_id = id;
					} else if( data.type == 'sentence_id' && data.type == expected_response ) {
						//TODO: chequear que el tipo de elemento es correcto
						var id : Id = data.data;
						check_id(id);
						sentence_id = id;
					} else if( data.type == 'full_post' && data.type == expected_response ) {
						log('Respuesta es un post.');
						var recived_post : Post = data.data;
						check_post(recived_post);
					} else if( data.type == 'sentence' && data.type == expected_response ) {
						var recived_sentence : Sentence = data.data;
						check_sentence(recived_sentence);
					} else if( data.type == 'sentence_removed' && data.type == expected_response ) {
						log('Sentence borrada');
					} else if( data.type == 'post_removed' && data.type == expected_response ) {
						log('Post borrado');
					} else if( data.type == 'error' && data.type == expected_response ) {
						log('Error recibido: ' + data.data);
					} else if( data.type == 'privkey' && data.type == expected_response ) {
						this.privkey = haxe.io.Int32Array.fromBytes(data.data);
						log('Private key:' + this.privkey);
						equal(privkey[0] != null, true);
						equal(privkey[1] != null, true);
						equal(privkey[2] != null, true);
						equal(privkey[3] != null, true);
					} else if( data.type == 'token' && data.type == expected_response ) {
						var token : haxe.io.Bytes = data.data;
						log( 'token recibido' );
						log( 'enviando auth' );
						expected_response = 'auth';
						connection.auth(privkey.view.getData().bytes, token);
						this.wait_server();
					} else if( data.type == 'auth' && data.type == expected_response ) {
						if( data.data == false ) {
							throw 'Error al autentificarse';
						}
					} else {
						trace( data );
						throw 'Respuesta inesperada';
						recived = false;
					}
					}
				});

				describe('Logueandose.', function() {
					this.it('Obteniedo privkey.', function() {
						expected_response = 'privkey';
						connection.create_privkey_with_login('tester', 'a_test_password,_thats_is_just_on_the_limit_of_sixty__chars');
						this.wait_server();
					});

					this.it('Autentificandose.', function() {
						expected_response = 'token';
						connection.get_token();
						this.wait_server();
					});
				});

				describe('Logueandose por async.', function() {
					this.it('Obteniedo privkey.', function() {
						var privkey : haxe.io.Int32Array = haxe.io.Int32Array.fromBytes(connection_async.create_privkey_with_login('tester', 'a_test_password,_thats_is_just_on_the_limit_of_sixty__chars'));
					});

					this.it('Autentificandose.', function() {
						equal(connection_async.auth(privkey.view.getData().bytes, connection_async.get_token()), true);
					});
				});

				describe('Probando post.', function() {
					this.it('Creando post.', function() {
						expected_response = 'post_id';
						expected_item = Post_item;
						connection.create_post(post_data);
						this.wait_server();
					});

					this.it('Obteniendo post.', function() {
						expected_response = 'full_post';
						connection.get_post(post_id, true);
						this.wait_server();
					});

					this.it('Eliminando post.', function() {
						expected_response = 'post_removed';
						connection.remove_post(post_id);
						this.wait_server();
					});

					this.it('Obteniendo error.', function() {
						expected_response = 'error';
						connection.get_post(post_id, true);
						this.wait_server();
					});
				});

				describe('Probando post por async.', function() {
					//for some strnage reason, every time dummy protocol assign extra data to r_post (line 117-120) or to r_sentence(line 125-127)
					// it also assigned to this post_data and this sentence, so I need to reset these vars.
					this.post_data = {
						info: {
							title: 'Hola',
							subtitle: 'mundo',
							overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum nisl enim, vitae pharetra ligula tristique commodo. Proin risus sapien, faucibus ac enim quis, scelerisque tincidunt arcu. Cras faucibus et neque id sagittis. Nullam rutrum mauris id scelerisque lacinia. Pellentesque in felis dignissim, posuere arcu ac, feugiat ipsum. Vivamus auctor fringilla lacus, ut efficitur dolor imperdiet a. Duis gravida, est imperdiet efficitur bibendum, felis ante tristique quam, vel malesuada elit arcu porttitor quam. Nullam non laoreet lacus.'},
						content: new HtmlDocument(''),
						tags: ['Lorem', 'ipsum']};


					this.it('Creando post.', function() {
						expected_item = Post_item;
						var data : Id = connection_async.create_post(this.post_data);
						check_id(data);
						post_id_nd = data;
					});

					this.it('Obteniendo post.', function() {
						var data : Post = connection_async.get_post(post_id_nd, true);
						check_post(data);
					});

					this.it('Eliminando post.', function() {
						equal(connection_async.remove_post(post_id_nd), true);
					});

					this.it('Obteniendo error.', function() {
						equal(connection_async.get_post(post_id_nd, true) == null, true);
					});
				});

				describe('Probando sentence.', function() {
					this.it('Creando sentence.', function() {
						expected_response = 'sentence_id';
						expected_item = Sentence_item;
						connection.create_sentence(sentence);
						this.wait_server();
					});

					this.it('Obteniendo sentence.', function() {
						expected_response = 'sentence';
						connection.get_sentence(sentence_id);
						this.wait_server();
					});

					this.it('Eliminando sentence.', function() {
						expected_response = 'sentence_removed';
						connection.remove_sentence(sentence_id);
						this.wait_server();
					});

					this.it('Obteniendo error.', function() {
						expected_response = 'error';
						connection.get_sentence(sentence_id);
						this.wait_server();
					});
				});

				describe('Probando sentence por async.', function() {
					//for some strnage reason, every time dummy protocol assign extra data to r_post (line 117-120) or to r_sentence(line 125-127)
					// it also assigned to this post_data and this sentence, so I need to reset these vars.
					this.sentence = {
						sentence: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'};

					this.it('Creando sentence.', function() {
						var data : Id = connection_async.create_sentence(sentence);
						check_id(data);
						sentence_id_nd = data;
					});

					this.it('Obteniendo sentence.', function() {
						var data : Sentence = connection_async.get_sentence(sentence_id_nd);
						check_sentence(data);
					});

					this.it('Eliminando sentence.', function() {
						expected_response = 'removed_sentence';
						equal(connection_async.remove_sentence(sentence_id_nd), true);
					});

					this.it('Obteniendo error.', function() {
						equal(connection_async.get_sentence(sentence_id_nd) == null, true);
					});
				});

			});
	}

	private function wait_server() : Void {
		var i : Int = 0;
		this.stamp_waiting = haxe.Timer.stamp();
		while( recived != true && i < 100000000 ) {
			i++;
			connection.refresh();
		}
		recived = false;
	}

	private function open_connection( host : String ) {
		connection = new Protocol(host, false, false);
		connection_async = new Protocol(host, true, false);

		connection.log = function( msg : String ){
			 this.log('[Protocol] ' + msg);
		};
		connection_async.log = function( msg : String ){
			 this.log('[Protocol] ' + msg);
		};
	}

	private function check_id( id : Id ) {
		check_length(2, id.first);
		check_length(2, id.second);
		check_length(2, id.third);
		equal(Type.enumEq(id.type, expected_item), true);
	}

	private inline function check_length(length : Int, item : Dynamic) : Void {
		equal(item.length == length, true);
	}

	private function check_post( t_post : Post ) {
		var t = new Tpost(t_post);
		equal(t.is_draft(), false);

		equal(t_post.content.toString(), this.post_data.content.toString());
		equal(t_post.concepts, this.post_data.concepts);
		equal(t_post.comments, this.post_data.comments);
		equal(t_post.topics, this.post_data.topics);
		equal(t_post.info.title, this.post_data.info.title);
		equal(t_post.info.subtitle, this.post_data.info.subtitle);
		equal(t_post.info.overview, this.post_data.info.overview);


		new Tuser_info(t_post.info.author);
		//TODO: comprobar si la id de usuario es la misma.


	}

	private function check_sentence( sentence : Sentence ) {
		var t = new Tsentence(sentence);
		equal(t.is_draft(), false);

		equal(sentence.sentence, this.sentence.sentence);

		new Tuser_info(sentence.author);
		//TODO: comprobar si la id de usuario es la misma.


	}
}
