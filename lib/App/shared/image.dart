class AppImages {
  static String get logo => 'logo'.png;
  static String get splash => 'splash'.png;
  static String get hidePassword => 'hidepassword'.png;
  static String get google => 'google'.png;
}

extension on String {
  String get png => "assets/images/$this.png";
}
