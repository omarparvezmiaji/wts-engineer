class Utils {
 static String greetingMessage(Map map){

    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return map['good_morning']?? 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return map['good_afternoon']?? 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return map['good_evening']??'Good Evening';
    } else {
      return map['good_night']??'Good Night';
    }
  }
}
