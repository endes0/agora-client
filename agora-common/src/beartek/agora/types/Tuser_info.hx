package beartek.agora.types;

import beartek.agora.types.Types;
import beartek.agora.types.Tid;
using hx.strings.Strings;

abstract Tuser_info(User_info) {

  public inline function new( info : User_info ) {
    if( info.username.length8() > 16 || info.username.isBlank() == true) throw 'Invalid username.';
    if( info.first_name.length8() > 8 ) throw 'Invalid first name.'; //TODO: mejorar.
    if( info.second_name.length8() > 8 ) throw 'Invalid second name.'; //TODO: mejorar.
    if(info.pinned_sentence != null) new Tid(info.pinned_sentence);
    new Tid(info.id);
    if( info.join_date < 0 ) throw 'Invalid join date.';
    if( info.join_date > info.last_login ) throw 'Invalid last login date.';

    this = info;
  }

  public static function equal( f_user : User_info, s_user : User_info) : Bool {
    if( f_user.first_name == s_user.first_name && f_user.second_name == s_user.second_name && f_user.username == s_user.username && f_user.join_date == s_user.join_date && Tid.equal(f_user.id, s_user.id) ) {
      return true;
    } else {
      return false;
    }
  }

  public inline function has_image() : Bool {
    return if(this.image_src.isBlank()) false else true;
  }
}
