//Under GNU AGPL v3, see LICENCE

package beartek.agora.client.web;

import org.tamina.html.component.HTMLApplication;
import org.tamina.i18n.LocalizationManager;
import js.html.Element;
import beartek.agora.types.Tpost;
import beartek.agora.types.Types;
import beartek.agora.client.web.pages.Dashboard;
import beartek.comps.Loader;
import beartek.comps.Animated_gradient;
import beartek.comps.Enter;
import beartek.comps.Login_form;
import htmlparser.HtmlDocument;


@:expose class Main extends HTMLApplication {
  public static var _instance : Main;


  static public function main() {
    _instance = new Main();
	}

  @:keep static public function init() {
    _instance.start();
  }

  public function new() {
    super();
  }

  public function start() : Void {
    try {
      #if dummy_server
      Jsons.server = {name: 'Dummy Server', host: 'dummy-host', secure: false};
      #else
      Jsons.server = haxe.Json.parse(haxe.Http.requestUrl('cfg/server.json'));
      #end
      Jsons.slogans = haxe.Json.parse(haxe.Http.requestUrl('assets/slogans.json')).slogans;
      //TODO: mejorar, ya que hay que cargar un archivo diferente por locale (no detecta el idioma)
      Jsons.translations = haxe.Json.parse(haxe.Http.requestUrl('assets/translations.json')).translations;
    } catch(e:Dynamic) {
      throw e;
    }

    this.loadComponents();
    if( Math.round(Math.random()) == 1 ) {
      js.Browser.document.getElementsByClassName('background')[0].style.backgroundImage = "url('assets/backround1.jpg')";
    }

    G_connection.open_connection(Jsons.server.host, false, Jsons.server.secure);
    G_connection.add_response_handler('error', this.on_error);
    G_connection.add_response_handler('auth', this.on_auth);
    G_connection.add_response_handler('privkey', this.on_privkey);
    G_connection.add_close_handler(this.on_close);

    G_connection.add_open_handler(function() : Void {
      if( Storage.get('privkey') != null ) {
        G_connection.g().auth(Storage.get('privkey'), G_connection.token);
      } else {
        if( js.Browser.document.getElementById('enter') == null ) {
          js.Browser.document.
        } else {
          this.show_enter();
        }
      }
    });
  }

  public function show_enter() : Void {
    js.Browser.document.getElementById('loader').remove();
    js.Browser.document.getElementById('enter').setAttribute('subtext', Jsons.slogans[Math.floor(Math.random() * Jsons.slogans.length)]);
    js.Browser.document.getElementById('enter').hidden = false;
  }

  public function login( form : Login_form ) : Void {
    var login : js.html.HTMLFormControlsCollection = form.login_form.elements;
    G_connection.g().create_privkey_with_login(untyped login.namedItem('username').value, untyped login.namedItem('password').value);
  }

  public function split() : Void {
    js.Browser.document.getElementById('section1').classList.add('division');
    js.Browser.document.getElementById('section2').hidden = false;
  }

  public function show_dashboard() : Void {
    js.Browser.document.getElementsByClassName('sections-row')[0].remove();
    var dashboard = HTMLApplication.createInstance(Dashboard);
    js.Browser.document.body.appendChild(dashboard);
  }

  public function on_close() : Void {
    haxe.Timer.delay(function() : Void {
      G_connection.open_connection(Jsons.server.host, false, Jsons.server.secure);
    }, 500);
    //Notify.info();
  }

  private function on_error( error : Error ) : Void {
    trace( error );
    if( error.type == 11 ) {
      if( js.Browser.document.getElementsByClassName('ui error message')[0].classList.contains('visible') ) {
        untyped $('.ui.error.message').transition('shake');
      } else {
        untyped $('.ui.error.message').transition('swing down');
      }
      js.Browser.document.getElementsByClassName('ui error message')[0].innerText = LocalizationManager.instance.getString('bad-loginkey');
    } else {
      js.Browser.alert(LocalizationManager.instance.getString('unknow-error') + error.type + ': ' + error.msg);
    }
  }

  private function on_auth( auth : Bool ) : Void {
    if( auth ) {
      this.show_dashboard();
    } else {
      js.Browser.document.getElementsByClassName('ui error message')[0].innerText = LocalizationManager.instance.getString('bad-auth');
      Storage.remove('privkey');
    }
  }

  private function on_privkey( privkey : haxe.io.Bytes ) : Void {
    Storage.remove('privkey');
    Storage.save('privkey', privkey);

    G_connection.g().auth(privkey, G_connection.token);
  }
}
