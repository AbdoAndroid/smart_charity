import 'package:bride_night/layouts/login.dart';
import 'package:bride_night/model/service.dart';
import 'package:bride_night/service/auth.dart';
import 'package:flutter/material.dart';

import '../service/services.dart';
import 'add_service.dart';

class ServiceProviderHome extends StatefulWidget {
  const ServiceProviderHome({Key? key}) : super(key: key);

  @override
  State<ServiceProviderHome> createState() => _ServiceProviderHomeState();
}

class _ServiceProviderHomeState extends State<ServiceProviderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                await logout();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              )),
        ],
      ),
      body: FutureBuilder<List<Service>>(
        future: getAllServicesForProvider(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              children = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('You did not created any service yet !'),
                ),
              ];
            } else {
              children = <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(30, 80, 20, 13),
                          width: 1.5,
                          style: BorderStyle.solid)),
                  child: Card(
                    elevation: 1,
                    color: Colors.transparent,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: const Color.fromARGB(255, 212, 230, 233),
                                //padding: EdgeInsets.all(6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 182, 200, 203),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Category: ${snapshot.data![index].category}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 16, 53, 79),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        snapshot.data![index].description ??
                                            'There is no description',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromARGB(255, 16, 53, 79),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                    'Price: ${snapshot.data![index].price}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromARGB(
                                                            255, 16, 53, 79))))),
                                        /*Flexible(
                                            flex: 1,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                  'تاريخ الانتهاء: ' +
                                                      snapshot.data![index].deadline!
                                                          .split('T')[0],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(255, 16, 53, 79))),
                                            )),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add New Service'),
                  content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const AddServiceDialog()),
                );
              });
        },
        //backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
