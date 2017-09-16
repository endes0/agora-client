package beartek.agora.types;

import beartek.agora.types.Types;
import beartek.agora.types.Tid;
import htmlparser.HtmlDocument;
import htmlparser.HtmlNodeElement;
using hx.strings.Strings;

abstract Tpost(Post) {

  static public var banned_attributes : Array<String> = ['href', 'download', 'target', 'form', 'formaction', 'formtarget', 'dirname', 'onafterprint', 'onbeforeprint', ];
  //TODO: no borrar img, pasar src por un cache server o proxy especificado.
  static public var banned_elements : Array<String> = ['a', 'applet', 'audio', 'base', 'embed', 'form', 'frame', 'iframe', 'img', 'link', 'main', 'menuitem', 'object', 'script', 'source', 'style', 'title', 'track', 'video'];


  public inline function new( post : Post ) {
    if( post.info != null && post.info.id == null ) {
      if (post.info.title.length < 3) throw 'Post title is too short.';

      post.comments = null;
      post.info.author = null;
      post.info.emoji_votes = null;
      post.info.publish_date = null;
      post.info.edit_date = null;
    } else if(post.info != null) {
      if (post.info.title.length < 3) throw 'Error on post title.';

      new Tid(post.info.id);
      new Tuser_info(post.info.author);

      for( vote_key in post.info.emoji_votes.keys() ) {
        if (vote_key.length8() > 2) throw 'Error on post votes.';
      }
      if (post.info.publish_date.getYear() < 2000) throw 'Error on post publish date.';
      if (post.info.edit_date != null && post.info.publish_date > post.info.edit_date) throw 'Post edit date mismatching with publish date.';
    }
    post.content = Tpost.check_content(post.content);

    this = post;
  }

  public inline function get() : Post {
    return this;
  }

  public inline function is_draft() : Bool {
    if( this.info != null && this.info.id == null ) {
      return true;
    } else {
      return false;
    }
  }

  public inline function is_full() : Bool {
    if(  this.info != null && this.info.id != null ) {
      return true;
    } else {
      return false;
    }
  }

  public inline function to_draft() {
    this.comments = null;
    this.info.author = null;
    this.info.emoji_votes = null;
    this.info.publish_date = null;
    this.info.edit_date = null;
  }

  public static function check_content( content : HtmlDocument ) : HtmlDocument {
    for( child in content.children ) {
      if( banned_elements.indexOf(child.name) != -1 ) {
        child.remove();
      } else {
        for( att_name in banned_attributes ) {
          child.removeAttribute(att_name);
        }

        var i : Int = 0;
        while( i > child.attributes.length ) {
          var a = child.attributes[i];
          if (StringTools.startsWith(a.name.toLowerCase(), 'on')) {
            child.attributes.splice(i, 1);
          } else {
            i++;
          }
        }

        if( child.children.length > 0 ) {
          check_child(child);
        }
      }
    }
    return content;
  }

  private static function check_child( content : HtmlNodeElement ) : HtmlNodeElement {
    for( child in content.children ) {
      if( banned_elements.indexOf(child.name) != -1 ) {
        child.remove();
      } else {
        for( att_name in banned_attributes ) {
          child.removeAttribute(att_name);
        }

        var i : Int = 0;
        while( i > child.attributes.length ) {
          var a = child.attributes[i];
          if (StringTools.startsWith(a.name.toLowerCase(), 'on')) {
            child.attributes.splice(i, 1);
          } else {
            i++;
          }
        }

        if( child.children.length > 0 ) {
          child = check_child(child);
        }
      }
    }
    return content;
  }
}
