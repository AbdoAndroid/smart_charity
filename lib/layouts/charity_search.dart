import 'package:flutter/material.dart';
import 'package:smart_charity/layouts/view_donation.dart';
import 'package:smart_charity/model/donation.dart';
import 'package:smart_charity/service/auth.dart';
import 'package:smart_charity/service/donations.dart';
import 'package:smart_charity/shared/constants.dart';

class CharitySearch extends StatefulWidget {
  const CharitySearch({Key? key}) : super(key: key);

  @override
  State<CharitySearch> createState() => _CharitySearchState();
}

class _CharitySearchState extends State<CharitySearch> {
  String? city;
  int category = 0;
  List<String> get _categories {
    return ["All Categories", ...categories];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //category
              Container(
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 3,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        // Initial Value
                        value: category,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: _categories.map((String items) {
                          return DropdownMenuItem<int>(
                            value: _categories.indexOf(items),
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (int? newValue) {
                          setState(() {
                            category = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //City
              Container(
                padding: EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "City",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 3,
                      child: FutureBuilder<List<String>>(
                          future: getCities(forSearch: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            Widget child;
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                child = const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('No cities !'),
                                );
                              } else {
                                child = DropdownButton<String>(
                                  isExpanded: true,
                                  // Initial Value
                                  value: city ?? snapshot.data![0],

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
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Donation>>(
            future: getCharityDonationsByCityAndCategory(
                category,
                city ??
                    'All cities'), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<Donation>> snapshot) {
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
                                                          .donorID),
                                                  builder: (context, snap) {
                                                    if (snapshot.hasData) {
                                                      return FittedBox(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          'By: ${snap.data}',
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
                                                '${_categories[snapshot.data![index].category + 1]}',
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            snapshot.data![index].description,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 16, 53, 79),
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
                                              donation:
                                                  snapshot.data![index])));
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
          ),
        )
      ],
    );
  }
}
