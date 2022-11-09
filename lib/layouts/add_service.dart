import 'package:bride_night/model/service.dart';
import 'package:bride_night/service/auth.dart';
import 'package:bride_night/service/services.dart';
import 'package:bride_night/shared/alert_dialog.dart';
import 'package:flutter/material.dart';

class AddServiceDialog extends StatefulWidget {
  const AddServiceDialog({Key? key}) : super(key: key);

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? city;
  String? category;
  final _formKey = GlobalKey<FormState>();
  saveData() async {
    if (_formKey.currentState!.validate()) {
      await addService(Service(
          id: '',
          description: descriptionController.text,
          category: category!,
          providerID: currentUser!.id,
          hasOffer: false,
          city: city!,
          fullAddress: fullAddressController.text,
          price: double.parse(priceController.text)));
      showAlertDialog(context, 'Saved Successfully');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //category
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Category",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: FutureBuilder<List<String>>(
                        future: getCategories(),
                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                          Widget child;
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              child = const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text('No Categories !'),
                              );
                            } else {
                              child = DropdownButton<String>(
                                // Initial Value
                                value: category ?? snapshot.data![0],

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
                                    category = newValue!;
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
            //City
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "City",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: FutureBuilder<List<String>>(
                        future: getCities(),
                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                          Widget child;
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              child = const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text('No cities !'),
                              );
                            } else {
                              child = DropdownButton<String>(
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
            //description
            Container(
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
            //address
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: fullAddressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required data !";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Full Address",
                  prefixIcon: Icon(
                    Icons.location_pin,
                    color: Color(0xFF2661FA),
                  ),
                ),
              ),
            ),
            //price
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required data !";
                  } else if (int.parse(value) <= 0) {
                    return "You should enter a positive value !";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixIcon: Icon(
                    Icons.attach_money,
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
    );
  }
}
