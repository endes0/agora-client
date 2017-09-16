package beartek.agora.client.web.pages.mains;

/**
 * @author Beartek
 * GNU AGPL v3
 * https://taksio.tk/beartek/agora
 */
import priori.view.container.PriScrollableContainer;
import priori.view.container.PriGroup;
import priori.bootstrap.PriBSFormInputText;
import priori.bootstrap.PriBSFormButton;
import priori.bootstrap.PriBSFormTextArea;
import priori.bootstrap.type.PriBSContextualType;
import priori.event.PriTapEvent;
import priori.event.PriEvent;
import ckeditor.CKEDITOR;
import ckeditor.Config;
import beartek.agora.types.Tpost;
import datetime.DateTime;
import htmlparser.HtmlDocument;

class Create extends PriScrollableContainer {
  var container : PriGroup = new PriGroup();
  var editor : PriGroup = new PriGroup();

  var title : PriBSFormInputText = new PriBSFormInputText();
  var subtitle : PriBSFormInputText = new PriBSFormInputText();
  var description : PriBSFormInputText = new PriBSFormInputText();
  var publish : PriBSFormButton = new PriBSFormButton();

  public function new() {
    super();
  }

  override private function setup() : Void {
    var config : Config = cast( { } );
    config.resize_enabled = false;
    config.height = '60vh';

    CKEDITOR.replace(editor.getJSElement(), config);
    container.addChild(editor);

    title.placeholder = 'Title';
    subtitle.placeholder = 'Subtitle';
    description.placeholder = 'Description';
    publish.text = 'Publish';
    publish.context = PriBSContextualType.INFO;
    publish.corners = [100,100,100,100];
    publish.addEventListener(PriTapEvent.TAP, function( e : PriEvent ) : Void {
      trace( CKEDITOR.instances );
      var post : Tpost = new Tpost({
        info: {
          title: title.value,
          subtitle: subtitle.value,
          overview: description.value,
          publish_date: DateTime.now()},
        tags: [],
        content: new HtmlDocument(Reflect.getProperty(CKEDITOR.instances, Reflect.fields(CKEDITOR.instances)[0]).getData())});
      G_connection.g().create_post(post);
    });

    this.addChild(container);
    this.addChild(title);
    this.addChild(subtitle);
    this.addChild(description);
    this.addChild(publish);
  }

  override private function paint() : Void {
    container.width = this.width/1.2;
    container.height = container.getElement().children('cke').height();

    container.centerX = this.width/2;
    container.y = 40;

    title.y = 40 + this.height/1.29;
    title.width = this.width/6;
    title.x = container.x;

    subtitle.y = title.y;
    subtitle.width = this.width/6;
    subtitle.x = title.maxX;

    description.y = title.y;
    description.width = this.width/3;
    description.x = subtitle.maxX;

    publish.y = title.y;
    publish.width = this.width/6;
    publish.maxX = container.maxX;
  }

}
