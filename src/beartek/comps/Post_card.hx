//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;
import org.tamina.html.component.HTMLApplication;
import beartek.agora.types.Tid;

@view('../template/comps/post_card.html')
class Post_card extends HTMLComponent {

  override public function attachedCallback() : Void {
    if(this.className == '') this.className = 'card';
  }

  override public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String) {
    switch attrName {
      case 'title': this.getElementsByClassName('header')[0].innerText = newVal;
      case 'subtitle': this.getElementsByClassName('meta')[0].innerText = newVal;
      case 'overview':
        if(newVal.length > 200) newVal = newVal.substr(0, 197) + '...';
        this.getElementsByClassName('description')[0].innerText = newVal;
      case 'author': this.getElementsByTagName('a')[0].innerText = newVal;
    }
  }

  private function open_navigator() : Void {
    untyped $('.fifteen.wide.stretched.column').transition('slide right', function() : Void {
      js.Browser.document.getElementsByClassName('fifteen wide stretched column')[0].setAttribute('style', 'display: none !important');
    });

    var p_v = HTMLApplication.createInstance(Post_viewer);
    p_v.post_id = Tid.fromString(this.getAttribute('post_id'));
    var v = HTMLApplication.createInstance(Viewer);
    v.view = p_v;
    //js.Browser.document.getElementsByClassName('ui padded grid')[0].insertBefore(v, js.Browser.document.getElementsByClassName('fifteen wide stretched column')[0]);
    js.Browser.document.getElementsByClassName('ui padded grid')[0].appendChild(v);
  }

}
