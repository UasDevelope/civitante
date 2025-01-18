class AppImages {
  static String get logo => 'logo'.png;
  static String get splash => 'splash'.png;
  static String get google => 'google'.png;
  static String get dotted => 'dotted'.png;
  static String get home => 'home'.png;
  static String get search => 'search'.png;
  static String get wallet => 'wallet'.png;
  static String get profile => 'profile'.png;
  static String get add => 'add'.png;
  static String get driving => 'driving'.png;
  static String get arrowback => "arrowback".png;
  static String get arrowup => "arrowup".png;
  static String get mycommunity => "mycommunity".png;
  static String get community => "community".png;
  static String get contactAdmin => 'contactAdmin'.png;
  static String get setting => "setting".png;
  static String get fqa => "fqa".png;
  static String get logout => 'logout'.png;
  static String get location => "location".png;
  static String get notification => "notification".png;
  static String get filter => "filter".png;
  static String get view => "view".png;
  static String get like => "like".png;
  static String get comment => "comment".png;
  static String get lock => "lock".png;
  static String get person => "person".png;
  static String get menue => "menue".png;
  static String get happend => "happend".png;
  static String get language => "language".png;
  static String get share => "share".png;
  static String get rectangle => "rectangle".png;
  static String get info => "info".png;
  static String get addCircle => "addCricle".png;
  static String get video => "video".png;
  static String get eidt => "edit".png;
  static String get camera => "camera".png;
  static String get calender => "calender".png;
  static String get clock => "clock".png;
  static String get copy => "copy".png;
  static String get tick => "tick".png;
  static String get chatCamera => "chatCamera".png;
  static String get emojie => "emojie".png;
}

extension on String {
  String get png => "assets/images/$this.png";
}
