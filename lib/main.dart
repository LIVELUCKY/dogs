import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dog.ceo"),
      ),
      body: Center(
        child: FutureBuilder<Map>(
          future: fetchDogsBreeds(),
          builder: (context, AsyncSnapshot<Map> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else {
                  Map? aux = snapshot.data;
                  if (aux == null) return Text("something went wrong");
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: aux.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = aux.keys.elementAt(index);
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(key),
                                  subtitle: Text(
                                    aux[key].toString().trim(),
                                  ),
                                ),
                                buildFutureBuilderImage(key),
                              ],
                            ),
                          );
                        }),
                  );
                  return Text('${snapshot.data}');
                }
            }
          },
        ),
      ),
    );
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
}
