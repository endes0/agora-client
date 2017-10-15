package beartek.agora.client.web.pages.mains;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriGroup;
import priori.event.PriEvent;
import priori.persistence.PriPersists;

class Logout extends PriGroup {

  public function new() {
    super();
    this.addEventListener(PriEvent.ADDED, function( e:PriEvent ) : Void {
      PriPersists.delete('privkey');
      G_connection.close_connection();
    });
  }

}
