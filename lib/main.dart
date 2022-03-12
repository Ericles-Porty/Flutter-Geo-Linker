import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geo_serialization/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

const google = "https://www.google.com/maps/place/";

void launchURL(String _url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

Future<List<User>> getHttp() async {
  var response = await Dio().get('https://jsonplaceholder.typicode.com/users');
  List<dynamic> datab = response.data;
  List<User> users = datab.map((x) => User.fromJson(x)).toList();
  return users;
}

String getUrl(String lng, String lat) => (lat + ',' + lng);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> url = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getHttp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<User> listaUsuarios = snapshot.data as List<User>;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: listaUsuarios.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    url.add(google +
                        getUrl(listaUsuarios[index].address.geo.lng,
                            listaUsuarios[index].address.geo.lat));
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 10,
                      child: Row(
                        children: [
                          Container(
                            width: 250,
                            height: 100,
                            color: Colors.black12,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nome: ' + listaUsuarios[index].name),
                                  Text('Usuario: ' +
                                      listaUsuarios[index].username),
                                  Text('Email: ' + listaUsuarios[index].email),
                                  Text('Telefone: ' +
                                      listaUsuarios[index].phone),
                                ]),
                          ),
                          Container(color: Colors.black,
                            padding: const EdgeInsets.all(2),
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/images/$index.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.black12)),
                              onPressed: () {
                                launchURL(url.elementAt(index));
                              },
                              child: const Text('Visitar'),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
