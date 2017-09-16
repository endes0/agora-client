package beartek.agora.types;

import beartek.agora.types.Types;
import beartek.agora.types.Tid;
import beartek.agora.types.Tuser_info;

using hx.strings.Strings;

abstract Tsentence(Sentence) {

  public inline function new( sentence : Sentence ) {
    if( sentence.id == null ) {
      sentence.author = null;
      sentence.publish_date = null;
      sentence.edit_date = null;
    } else {
      new Tid(sentence.id);
      new Tuser_info(sentence.author);
      if(sentence.publish_date < 0) throw 'Invalid publish_date.';
      if(sentence.edit_date != null && sentence.publish_date > sentence.edit_date) throw 'Invalid edit date.';
    }

    if( sentence.sentence.length8() > 200 ) throw 'Invalid sentence.'; //TODO: mejorar
    this = sentence;
  }

  public inline function get() : Sentence {
    return this;
  }

  public inline function is_draft() : Bool {
    return if(this.id == null) true else false;
  }

  public inline function to_draft() : Void {
    this.id = null;
    this.author = null;
    this.publish_date = null;
    this.edit_date = null;
  }
}
