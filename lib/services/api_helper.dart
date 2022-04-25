import 'package:http/http.dart';

class ApiHelper {
  static String _baseUrl = 'http://192.168.46.119:8000/';
  static String _searchConference = 'search/conferences/';

  static String getSearchConferenceURL(String userId) {
    return _baseUrl + _searchConference + '$userId?' + 'count=5';
  }

  static String getFavouriteConferenceURL(String userId) {
    return _baseUrl + 'user/$userId/favourite_conferences';
  }

  static String getInvitedConferenceURL(String userId) {
    return _baseUrl + 'user/$userId/invited_to_conference?from=1&to=20';
  }

  static String getLastJoinedConferenceURL(String userId) {
    return _baseUrl + 'user/$userId/last_joined_conferences?from=1&to=20';
  }

  static Future<bool> setFavouriteConference(
      String userId, String conferenceId) async {
    try {
      final uri = Uri.parse(
          _baseUrl + 'user/$userId/set_favourite_conference/$conferenceId');
      Response response = await post(uri);
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 202)
        return true;
      else {
        print('Status code is $statusCode');
        return false;
      }
    } catch (e) {
      print('Exception occured: $e');
    }
    return false;
  }

  static Future<bool> unsetFavouriteConference(
      String userId, String conferenceId) async {
    try {
      final uri = Uri.parse(
          _baseUrl + 'user/$userId/unset_favourite_conference/$conferenceId');
      Response response = await post(uri);
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 202)
        return true;
      else {
        print('Status code is $statusCode');
        return false;
      }
    } catch (e) {
      print('Exception occured: $e');
    }
    return false;
  }
}
