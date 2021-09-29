import 'package:dogs/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BreedViewer extends StatelessWidget {
  const BreedViewer({Key? key, required this.breed}) : super(key: key);
  final String breed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.toUpperCase()),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
            future: fetchDogsByBreed(breed),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else {
                    List<String>? aux = snapshot.data;
                    if (aux == null) return Text("something went wrong");
                    return ListView.builder(
                      itemCount: aux.length,
                      itemBuilder: (context, index) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                aux[index],
                                fit: BoxFit.scaleDown,
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
              }
            }),
      ),
    );
  }
}
