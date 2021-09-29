import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> fetchRandom() async {
  final response =
  await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body)['message'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<String> fetchRandomFromBreed(String breed) async {
  final response = await http
      .get(Uri.parse('https://dog.ceo/api/breed/$breed/images/random'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body)['message'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Map> fetchDogsBreeds() async {
  final response =
  await http.get(Uri.parse('https://dog.ceo/api/breeds/list/all'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> aux =
    Map<String, dynamic>.from(json.decode(response.body)['message']);
    aux.removeWhere((key, value) => value.isEmpty);
    return aux;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}