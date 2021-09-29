import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    throw Exception('Failed to load Random Picture');
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
    throw Exception('Failed to load Random Picture from Breed');
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
    throw Exception('Failed to load Dog Breeds');
  }
}

Future<List<String>> fetchDogsByBreed(String breed) async {
  final response =
      await http.get(Uri.parse('https://dog.ceo/api/breed/$breed/images'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<String> aux = List<String>.from(json.decode(response.body)['message']);
    return aux;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Pictures from Breed');
  }
}

FutureBuilder<String> buildFutureBuilderImage(String key) {
  return FutureBuilder(
    future: fetchRandomFromBreed(key),
    builder: (context, AsyncSnapshot<String> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return CircularProgressIndicator();
        default:
          if (snapshot.hasError || snapshot.data == null)
            return Text('Error: ${snapshot.error}');
          else {
            return Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.scaleDown,
                ),
              ),
            );
          }
      }
      // Text(fetchRandomFromBreed(key)),
    },
  );
}
