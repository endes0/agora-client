package beartek.agora.client.web.comp.login;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.bootstrap.PriBSFormInputText;
import priori.bootstrap.PriBSFormButton;
import priori.bootstrap.type.PriBSSize;
import priori.bootstrap.type.PriBSContextualType;
import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.style.border.PriBorderStyle;
import priori.style.font.PriFontStyle;
import priori.style.font.PriFontStyleAlign;
import priori.style.font.PriFontStyleWeight;
import priori.geom.PriColor;
import priori.event.PriEvent;
import priori.event.PriTapEvent;
import beartek.agora.client.web.comp.bs.BStab;

 class Menu extends PriGroup {
   public var c1 : PriColor;
   public var c2 : PriColor;

   var tab : BStab;

   var login_screen : PriGroup;
   var welcome : PriText;
   var username : PriBSFormInputText;
   var password : PriBSFormInputText;
   var forgot_pass : PriText;
   var change_server : PriText;
   var center_divisor : PriText;
   var login_button : PriBSFormButton;

   var register_screen : PriGroup;


   public function new() {
     super();
   }

   override private function setup() : Void {
     this.border = new PriBorderStyle(5);
     this.tab = new BStab();

     this.login_screen = new PriGroup();
     this.welcome = new PriText();
     this.username = new PriBSFormInputText();
     this.password = new PriBSFormInputText();
     this.forgot_pass = new PriText();
     this.change_server = new PriText();
     this.center_divisor = new PriText();
     this.login_button = new PriBSFormButton();
     var fontstyle : PriFontStyle = new PriFontStyle(new PriColor(0x757575));
     fontstyle.weight = PriFontStyleWeight.THICK500;
     var fontstyle2 : PriFontStyle = new PriFontStyle(new PriColor(0x9b9b9b));

     this.corners = [3,3,3,3];
     this.dh.elementBorder.style.borderImage = 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')';
     this.dh.elementBorder.style.borderImageSlice = '1';

     this.tab.data = new Array();
     this.tab.data.push({
            title : 'Login',
            content: this.login_screen
          });
     this.tab.data.push({
            title : 'Register',
            content: this.register_screen
          });
     this.tab.labelField = "title";
     this.tab.justified = true;
     this.tab.addEventListener(PriEvent.CHANGE, tab_change);
     this.tab.selected = this.tab.data[0];

     this.addChild(tab);


     this.welcome.fontSize = 20;
     this.welcome.fontStyle = fontstyle;
     this.welcome.text = 'Login in to ' + if(Jsons.server != null) Jsons.server.name else 'Unknow server';

     this.username.placeholder = 'Username';
     this.username.tooltip = this.username.placeholder;
     this.password.placeholder = 'Password';
     this.password.tooltip = this.password.placeholder;
     this.password.password = true;

     this.forgot_pass.fontStyle = fontstyle2;
     this.forgot_pass.text = 'Forgot password?';
     this.change_server.fontStyle = fontstyle2;
     this.change_server.text = 'Change server?';
     this.center_divisor.fontStyle = fontstyle2;
     this.center_divisor.text = '|';

     this.login_button.corners = [100,100,100,100];
     this.login_button.text = 'Login';
     this.login_button.size = PriBSSize.LARGE;
     this.login_button.context = PriBSContextualType.SUCCESS;
     this.login_button.addEventListener(PriTapEvent.TAP, this.on_login);

     this.login_screen.addChild(welcome);
     this.login_screen.addChild(username);
     this.login_screen.addChild(password);
     this.login_screen.addChild(center_divisor);
     this.login_screen.addChild(forgot_pass);
     this.login_screen.addChild(change_server);
     this.login_screen.addChild(login_button);
     this.addChild(login_screen);
   }

   override private function paint() : Void {
     tab.width = this.width-12;
     tab.centerX = this.width/2;
     tab.y = 6;

     if( this.tab.selected.content == this.login_screen ) {
       login_screen.y = tab.maxY;

       login_screen.height = this.height - tab.maxY;
       login_screen.width = this.width;

       welcome.width = this.login_screen.width-40;
       welcome.centerY = 40;
       welcome.centerX = this.login_screen.width/2;

       username.width = this.login_screen.width-40;
       password.width = this.login_screen.width-40;
       username.centerX = this.login_screen.width/2;
       password.centerX = this.login_screen.width/2;
       username.y = 75;
       password.y = username.maxY +10;

       center_divisor.centerX = this.login_screen.width/2;
       forgot_pass.x = password.x +5;
       change_server.maxX = password.maxX -5;
       center_divisor.y = password.maxY;
       forgot_pass.y = center_divisor.y;
       change_server.y = center_divisor.y;

       login_button.width = this.login_screen.width-40;
       login_button.y = center_divisor.maxY +10;
       login_button.centerX = this.login_screen.width/2;
     } else {
       trace( '...' );
     }
   }

   private function tab_change(e:PriEvent) : Void {
     if(this.tab.selected.content == this.login_screen ) {
       //this.dh.elementBorder.style.borderImage = 'linear-gradient(to bottom right, ' + c1.toString() + ', ' + c2.toString() + ')';
       this.removeChild(this.register_screen);
       this.addChild(this.login_screen);
     } else {
       //this.dh.elementBorder.style.borderImage = 'linear-gradient(to bottom left, ' + c1.toString() + ', ' + c2.toString() + ')';
       this.removeChild(this.login_screen);
       this.addChild(this.register_screen);
     }
   }

   private function on_login( e: PriEvent ) : Void {
     G_connection.g().create_privkey_with_login(username.value, password.value);
   }

 }
