package beartek.agora.client.web;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.app.PriApp;
import priori.assets.AssetImage;
import priori.assets.AssetManager;
import priori.assets.AssetManagerEvent;
import priori.net.*;
import priori.scene.manager.SceneManager;
import priori.event.PriEvent;
import priori.persistence.PriPersists;
import beartek.agora.types.Tpost;
import beartek.agora.client.web.pages.Login;
import beartek.agora.client.web.pages.Main_page;
import htmlparser.HtmlDocument;


class Main extends PriApp {
  var assets_ready : Bool = false;
  var jsons_loaded : Int = 0;

  static public function main() {
        new Main();
	}

  public function new() {
    super();

    AssetManager.g().addToQueue(new AssetImage('backround', 'assets/backround.jpg'));
    AssetManager.g().addEventListener(AssetManagerEvent.ASSET_COMPLETE, function(e:AssetManagerEvent):Void {
      this.assets_ready = true;

      AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_COMPLETE);
      AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_ERROR);
      AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_PROGRESS);

      this.can_start();
    });
    AssetManager.g().load();


    var server_cfg = new PriURLRequest('cfg/server.json');
    var slogans = new PriURLRequest('assets/slogans.json');
    server_cfg.contentType = PriRequestContentType.APPLICATION_JSON;
    slogans.contentType = PriRequestContentType.APPLICATION_JSON;

    var request = new PriURLLoader();
    request.load(server_cfg);
    request.load(slogans);
    request.addEventListener(PriEvent.COMPLETE, function( e: PriEvent ) {
      var data : Dynamic = haxe.Json.parse(e.data);

      if( data.name == 'server_cfg' ) {
        Jsons.server = data.data;
      } else if( data.name == 'slogans' ) {
        Jsons.slogans = data.data;
      } else {
        throw 'Invalid Json recived.';
      }

      jsons_loaded++;
      this.can_start();
    });
    request.addEventListener(PriEvent.ERROR, function( e: PriEvent ) {
      //Notify.error();
      jsons_loaded++;
      this.can_start();
    });

  }

  public function can_start() : Void {
    if( assets_ready && jsons_loaded == 2 ) {
      this.start();
    }
  }

  public function start() : Void {
    #if dummy_server
    Jsons.server = {name: 'Dummy Server', host: 'dummy-host', secure: false};
    #end

    if( Jsons.server != null ) {
      G_connection.open_connection(Jsons.server.host, false, Jsons.server.secure);
    } else {
      //Notify.error();
    }

    G_connection.add_response_handler('auth', this.on_auth);
    G_connection.add_response_handler('privkey', this.on_privkey);
    G_connection.add_close_handler(this.on_close);

    if( PriPersists.load('privkey') != null ) {
      G_connection.add_open_handler(function() : Void {
        G_connection.g().auth(PriPersists.load('privkey'), G_connection.token);
      });
    } else {
      SceneManager.g().open(Login);
    }
  }

  public function on_close() : Void {
    haxe.Timer.delay(this.start, 500);
    //Notify.info();
  }

  private function on_auth( auth : Bool ) : Void {
    if( auth ) {
      #if dummy_server
        G_connection.g().create_post({
      		info: {
      			title: 'Hola',
      			subtitle: 'mundo',
      			overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum nisl enim, vitae pharetra ligula tristique commodo. Proin risus sapien, faucibus ac enim quis, scelerisque tincidunt arcu. Cras faucibus et neque id sagittis. Nullam rutrum mauris id scelerisque lacinia. Pellentesque in felis dignissim, posuere arcu ac, feugiat ipsum. Vivamus auctor fringilla lacus, ut efficitur dolor imperdiet a. Duis gravida, est imperdiet efficitur bibendum, felis ante tristique quam, vel malesuada elit arcu porttitor quam. Nullam non laoreet lacus.'},
      		content: new HtmlDocument('<div class="container">
      <p>Hola, esto es un prueba de un articulo, como veis en los articulos se pueden usar una amplia gama de elementos y atributos, incluso clases de bootstrap:</p>
      <div class="row">
        <div class="col-md-4">
          <h2>Heading</h2>
          <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
          <p><a class="btn btn-secondary" href="#" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>Heading</h2>
          <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
          <p><a class="btn btn-secondary" href="#" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>Heading</h2>
          <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
          <p><a class="btn btn-secondary" href="#" role="button">View details &raquo;</a></p>
        </div>
      </div>
      <p>Pero hay otros, que por motivos de seguridad estan bloqueados como por ejemplo, aqui deberia haber un hipervinculo -> <a href="http://example.com">esto deberiaser un hipervinculo con enlace externo</a></p>

    </div>'),
      		tags: ['Lorem', 'ipsum']});
      #end
      SceneManager.g().open(Main_page);
    } else {
      //Notify.error();
      SceneManager.g().open(Login);
    }
  }

  private function on_privkey( privkey : haxe.io.Bytes ) : Void {
    PriPersists.delete('privkey');
    PriPersists.save('privkey', privkey);

    G_connection.g().auth(privkey, G_connection.token);
  }
}
