import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geo_serialization/models/user.dart';

Future<List<User>> getHttp() async {
  var response = await Dio().get('https://jsonplaceholder.typicode.com/users');
  List<dynamic> datab = response.data;
  List<User> users = datab.map((x) => User.fromJson(x)).toList();
  return users;
}

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
                    return Container(
                      child: Text('latitude: ' + listaUsuarios[index].address.geo.lat + ' longitude: ' + listaUsuarios[index].address.geo.lng),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
