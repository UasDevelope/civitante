import 'package:civitante/App/Models/User.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/widgets.dart';

class FollowListController extends GetxController{

  Rxn<UserMatch> user = Rxn<UserMatch>();

  Future<void> getFollowers(String url) async {
    print("Fetching followers...");

    try {
      var response = await HttpService.get(url);
      print("Response for followers is: $response");

      if (response == null) {
        print("Error: Response is null");
        return;
      }

      user.value = UserMatch.fromJson(response);
      print("User data updated: ${user.value?.toJson()}");
      user.refresh();
    } catch (e) {
      print("Error fetching followers: $e");
    }
  }



}