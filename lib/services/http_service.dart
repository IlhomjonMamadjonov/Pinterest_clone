import 'dart:convert';

import 'package:http/http.dart';
import 'package:unsplash_demo/models/splash_model.dart';

class Network {
  /// isTester
  static bool isTester = true;

  /// Servers
  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com";

  /// Http Apis
  static String API_LIST = "/photos";
  static String API_SEARCH = "/search/photos";
  static String API_ONE = "/photos/"; //{id}
  static String API_CREATE = "/photos";
  static String API_UPDATE = "/photos/"; //{id}
  static String API_DELETE = "/photos/"; //{id}

  /// Getting Header
  static Map<String, String> getHeaders() {
    Map<String, String> header = {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept-Version": "v1",

      "Authorization": "Client-ID Vj5tMzxlk6JAAxd4BUF5Z7mHtZpe5UrndwKhc_Uc1jk"
    };
    return header;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /// *Http Requests

  /// GET
  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// POST
  static Future<String?> POST(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response =
        await post(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /// PUT
  static Future<String?> PUT(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response =
        await put(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// PATCH
  static Future<String?> PATCH(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
        await patch(uri, body: jsonEncode(params), headers: getHeaders());
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /// DELETE
  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// *Http Params

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({"page": pageNumber.toString()});
    return params;
  }

  static Map<String, dynamic> paramSearch(String search, int pageNumber) {
    Map<String, String> params = {};
    params.addAll({"page": pageNumber.toString(), "query": search});
    return params;
  }

  /// *PARSING

  static List<UnSplash> parseResponse(String response) {
    List json = jsonDecode(response);
    List<UnSplash> photos =
        List<UnSplash>.from(json.map((e) => UnSplash.fromJson(e)));
    return photos;
  }

  static List<UnSplash> parseSearch(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    List<UnSplash> photos =
        List<UnSplash>.from(json["results"].map((e) => UnSplash.fromJson(e)));
    return photos;
  }
}
