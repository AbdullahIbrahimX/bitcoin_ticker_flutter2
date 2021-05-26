import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  Uri _uri;
  String _website;
  String _path;
  Map<String, dynamic> _queries;
  Map<String, dynamic> _headers;

  NetworkHelper({website, path, queries, headers})
      : _website = website ?? "",
        _path = path ?? "",
        _queries = queries ?? {},
        _headers = headers ?? {} {
    _queries.isEmpty
        ? _uri = Uri.https(_website, _path)
        : _uri = Uri.https(_website, _path, _queries);
  }

  Future getData() async {
    try {
      print(_uri);
      http.Response response = await http.get(
        _uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.statusCode.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
