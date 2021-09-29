import 'package:dogs/breed.dart';
import 'package:dogs/providers.dart';
import 'package:flutter/material.dart';

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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BreedViewer(breed: key),
                                  ));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(key),
                                    subtitle: Text(
                                      aux[key].toString().trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  buildFutureBuilderImage(key),
                                ],
                              ),
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
}
