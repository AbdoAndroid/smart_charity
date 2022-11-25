import 'package:flutter/material.dart';
import 'package:smart_charity/layouts/view_donation.dart';
import 'package:smart_charity/model/donation.dart';
import 'package:smart_charity/service/donations.dart';

import '../service/auth.dart';
import '../shared/constants.dart';

class CharityDonations extends StatefulWidget {
  const CharityDonations({Key? key, required this.status}) : super(key: key);
  final int status;
  @override
  State<CharityDonations> createState() => _CharityDonationsState();
}

class _CharityDonationsState extends State<CharityDonations> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Donation>>(
      future: getCharityDonations(
          widget.status), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<Donation>> snapshot) {
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
                child: Text('No donations found !'),
              ),
            ];
          } else {
            children = <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        child: GestureDetector(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 182, 200, 203),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: FutureBuilder<String>(
                                            future: getNameByUsername(
                                                snapshot.data![index].donorID),
                                            builder: (context, snap) {
                                              if (snapshot.hasData) {
                                                return FittedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'By: ${snap.data}',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 16, 53, 79),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: const Text(
                                                    'By: ',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 16, 53, 79),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        Text(
                                          '${categories[snapshot.data![index].category]}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 16, 53, 79),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      snapshot.data![index].description,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 16, 53, 79),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'City: ${snapshot.data![index].city}',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 16, 53, 79),
                                            ),
                                          ),
                                        ),
                                      ),
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewDonation(
                                        donation: snapshot.data![index])));
                          },
                        ),
                      );
                    }),
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
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }
}
