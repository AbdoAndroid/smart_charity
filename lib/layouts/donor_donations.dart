import 'package:flutter/material.dart';
import 'package:smart_charity/layouts/view_donation.dart';
import 'package:smart_charity/model/donation.dart';
import 'package:smart_charity/service/donations.dart';
import 'package:smart_charity/shared/constants.dart';

import '../service/auth.dart';

class DonorDonations extends StatefulWidget {
  const DonorDonations({Key? key, required this.status}) : super(key: key);
  final int status;
  @override
  State<DonorDonations> createState() => _DonorDonationsState();
}

class _DonorDonationsState extends State<DonorDonations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            /*child: Row(
              children: [
                Text(
                  "City",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<String>>(
                      future: getCities(forSearch: true),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        Widget child;
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            child = const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child:
                              Text('You did not created any service yet !'),
                            );
                          } else {
                            child = DropdownButton<String>(
                              // Initial Value
                              value: city,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: snapshot.data!.map((String items) {
                                return DropdownMenuItem<String>(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  city = newValue!;
                                });
                              },
                            );
                          }
                        } else if (snapshot.hasError) {
                          child = Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          child = Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          );
                        }
                        return child;
                      }),
                ),
              ],
            ),*/
          ),
          FutureBuilder<List<Donation>>(
            future: getDonorDonations(
                widget.status), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<Donation>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  children = <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('No Service at this city yet !!'),
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
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewDonation(
                                            donation: snapshot.data![0])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    color: const Color.fromARGB(
                                        255, 212, 230, 233),
                                    //padding: EdgeInsets.all(6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 182, 200, 203),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: FutureBuilder<String>(
                                                  future: getNameByUsername(
                                                      snapshot.data![index]
                                                          .charityID),
                                                  builder: (context, snap) {
                                                    if (snapshot.hasData) {
                                                      return FittedBox(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          'For: ${snap.data}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    16,
                                                                    53,
                                                                    79),
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
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    16,
                                                                    53,
                                                                    79),
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
                                                  color: Color.fromARGB(
                                                      255, 16, 53, 79),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            snapshot.data![index].description,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 16, 53, 79),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Colors.white38,
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                          'City: ${snapshot.data![index].city.toString()}',
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      16,
                                                                      53,
                                                                      79)))),
                                                )),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
