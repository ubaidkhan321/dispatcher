import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart';

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    // print(query);
    var secret = globals.secret_key;
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }
    // const apiUrl =
    //     'https://rholabproducts.com/rhocom_suppliers/api/mobileapp/customers/lists';

    const apiUrl = 'https://rholabproducts.com/api/mobileapp/customers/lists';

    // const apiUrl =
    //     'https://rhotrack.rholabproducts.com/api/mobileapp/customers/lists';
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "text": query
    });
    final data = json.decode(response.body);
    // print("Data here");
    // print(data['code_status']);

    List<Suggestion> suggestions = [];

    if (data['code_status'] == true) {
      Iterable json = data['customers'];
      // print(json);
      suggestions = List<Suggestion>.from(
          json.map((model) => Suggestion.fromJson(model)));

      // print('Number of suggestion: ${suggestions.length}.');
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(suggestions
        .map((e) => {'name': e.name.toString(), 'id': e.id.toString()})
        .toList());
  }

  static Future<List<Map<String, String>>> getWerehouse(String query) async {
    // print(query);
    var secret = globals.secret_key;
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }
    const apiUrl = 'https://rholabproducts.com/api/mobileapp/suppliers/lists';
    // const apiUrl =
    //     'https://rhotrack.rholabproducts.com/api/mobileapp/suppliers/lists';
    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "text": query
    });
    final data = json.decode(response.body);
    // print("Data here");
    print(data);

    List<Suggestion> suggestions = [];

    if (data['code_status'] == true) {
      Iterable json = data['suppliers'];
      print(json);
      suggestions = List<Suggestion>.from(
          json.map((model) => Suggestion.fromJson(model)));

      // print('Number of suggestion: ${suggestions.length}.');
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(suggestions
        .map((e) => {'name': e.name.toString(), 'id': e.id.toString()})
        .toList());
  }
}

class Suggestion {
  final String id;
  final String name;

  Suggestion({
    required this.id,
    required this.name,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'],
      name: json['name'],
    );
  }
}
