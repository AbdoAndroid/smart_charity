import 'package:flutter/material.dart';
import 'package:smart_charity/model/donation.dart';
import 'package:smart_charity/model/user.dart';
import 'package:smart_charity/service/auth.dart';
import 'package:smart_charity/service/donations.dart';
import 'package:smart_charity/shared/alert_dialog.dart';
import 'package:smart_charity/shared/constants.dart';

class AddDonation extends StatefulWidget {
  const AddDonation({Key? key}) : super(key: key);

  @override
  State<AddDonation> createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  TextEditingController descriptionController = TextEditingController();
  String? city;
  int category = 0;
  String? charityIndex;
  final _formKey = GlobalKey<FormState>();
  saveData() async {
    if (_formKey.currentState!.validate()) {
      await addDonation(Donation(
        id: '',
        description: descriptionController.text,
        category: category,
        donorID: currentUser!.username,
        city: City(city!),
        status: 0,
        charityID: charityIndex!,
      ));
      showAlertDialog(context, 'Saved Successfully');
      descriptionController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //category
              Container(
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        // Initial Value
                        value: category,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: categories.map((String items) {
                          return DropdownMenuItem<int>(
                            value: categories.indexOf(items),
                            child: Center(
                              child: Text(
                                items,
                              ),
                            ),
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
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        "City",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<String>>(
                          future: getCities(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            Widget child;
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                child = const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Center(child: Text('No cities !')),
                                );
                              } else {
                                city = city ?? snapshot.data![0];
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
                                      child: Center(child: Text(items)),
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
              //Charity
              Container(
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      "Charity",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: FutureBuilder<List<User>>(
                          future: getCharities(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<User>> snapshot) {
                            Widget child;
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                child = const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('No Charities !'),
                                );
                              } else {
                                charityIndex =
                                    charityIndex ?? snapshot.data![0].username;
                                child = DropdownButton<String>(
                                  isExpanded: true,
                                  // Initial Value
                                  value: charityIndex ??
                                      snapshot.data![0].username,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: snapshot.data!.map((User items) {
                                    return DropdownMenuItem<String>(
                                      value: items.username,
                                      child: Center(child: Text(items.name)),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      charityIndex = newValue;
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
              //description
              Container(
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required data !";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => saveData(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("Save"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
