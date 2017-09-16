package beartek.agora.client.test;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
 import beartek.agora.client.test.Test_server;
 import beartek.agora.client.test.Dummy_server;

 class Test_protocol extends Test_server {

   public function new() {
     super('dummy-host');
   }

   override private function open_connection( host : String ) {
    this.connection = new Protocol('dummy-host', this.create_connection);
 		this.connection_async = new Protocol('dummy-host', true, this.create_connection);

    connection.log = function( msg : String ){
       log('[Protocol] ' + msg);
    };
    connection_async.log = function( msg : String ){
       log('[Protocol] ' + msg);
    };
   }

   public function create_connection( host : String ) : Dynamic {
     var t = new Dummy_server();
     return t;
   }
 }
