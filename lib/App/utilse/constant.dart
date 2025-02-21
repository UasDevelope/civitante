import 'dart:ffi';

class AppConstant {
  // Private constructor
  AppConstant._privateConstructor();
  // Single shared instance
  static final AppConstant _instance = AppConstant._privateConstructor();

  // Factory constructor to return the same instance
  factory AppConstant() {
    return _instance;
  }

  String? userID;
  String? cityName;
  bool? paymentID;
  String baseUrl = 'http://16.170.211.87:5000/user';

  // Cloudinary
  String Cloudinary_API_KEY = "239661546466672";
  String Cloudinary_Secret_KEY = "qtBd8gIDExqgVVyIxrtJC3HgmF0";
  String Cloud_Name = "dqv0rpgrw";
  String Upload_Preset = "Here_now";
  //Stripe public keys
  String stripepublishableKey = 'your_publishable_key';

// Method: POST
  String login = '/login';
  String addPost = '/addPost';
  String getPosts = '/getPosts';
  String getPostById = '/getPostById/';
  String editPost = '/editpost/';
  String deletePost = '/deletePost/';
  String addLikeToPost = '/addLikeToPost/';
  String addCommentToPost = '/addCommentToPost/';
  String addLikeToComment = '/addLikeToComment/';
  String addReplyToComment = '/addReplyToComment/';
  String savePaymentMethod = '/savePaymentMethod';
  String charge = '/charge';
  String upgradeToPro = '/upgradeToPro';
  String getProfile = '/getProfile';
}
