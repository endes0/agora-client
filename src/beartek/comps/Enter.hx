//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;

@view('../template/comps/enter.html')
class Enter extends HTMLComponent {

  override public function attachedCallback() : Void {
    this.classList.add('enter');
  }

  override public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String) {
    if( attrName == 'subtext' ) {
      this.getElementsByClassName('heading')[1].innerText = newVal;
    }
  }

  private function clicked() : Void {
    this.getElementsByClassName('button')[0].remove();
    js.Lib.eval(this.attributes.getNamedItem('on-click').value);
  }

}
