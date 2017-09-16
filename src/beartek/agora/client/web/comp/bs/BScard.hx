package beartek.agora.client.web.comp.bs;

import priori.view.container.PriGroup;
import priori.view.text.PriText;
import priori.event.PriEvent;

class BScard extends PriGroup {

    public function new() {
        super();

        this.getElement().addClass('card');
    }

    override private function setup() : Void {
      this.setCSS('position', 'absolute');
    }

}
