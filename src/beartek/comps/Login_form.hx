//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;
import org.tamina.i18n.LocalizationManager;

@view('../template/comps/login_form.html')
class Login_form extends HTMLComponent {
  public var login_form : Dynamic;

  public function new() : Void {
    super();
  }

  override public function attachedCallback() : Void {
    this.login_form = this.getElementsByTagName('form')[0];

    untyped $('#login').form({
      fields: {
        username: {
          identifier: 'username',
          rules: [{
            type   : 'empty',
            prompt : LocalizationManager.instance.getString("empty-field")
          },
          {
            type   : 'maxLength[16]',
            prompt : LocalizationManager.instance.getString("max-username")
          }]
        },
        password: {
          identifier: 'password',
          rules: [{
            type   : 'empty',
            prompt : LocalizationManager.instance.getString("empty-field")
          },
          {
            type   : 'minLength[8]',
            prompt : LocalizationManager.instance.getString("min-password")
          },
          {
            type   : 'maxLength[59]',
            prompt : LocalizationManager.instance.getString("max-password")
          }]
        }
      },
      'inline': true,
      on: 'blur'
    });
  }

  private function send_form( form : js.html.FormElement ) : Bool {
    if( untyped $('#login').form('is valid') ) {
      var code : String = this.attributes.getNamedItem('submit').value;
      if( code == '' || code == null ) {
        js.Browser.alert('The form was send but no action was sepcified (internal error)');
      } else {
        js.Lib.eval(code);
      }
    }
    return false;
  }
}
