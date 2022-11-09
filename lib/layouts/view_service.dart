import 'package:bride_night/model/service.dart';
import 'package:bride_night/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewService extends StatefulWidget {
  const ViewService({Key? key, required this.service}) : super(key: key);
  final Service service;
  @override
  State<ViewService> createState() => _ViewServiceState();
}

class _ViewServiceState extends State<ViewService> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryController = TextEditingController(text: widget.service.category);
    descriptionController = TextEditingController(text: widget.service.description);
    cityController = TextEditingController(text: widget.service.city);
    fullAddressController = TextEditingController(text: widget.service.fullAddress);
    priceController = TextEditingController(text: widget.service.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View service details'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //category
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: categoryController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    prefixIcon: Icon(
                      Icons.category,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              //description
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: descriptionController,
                  readOnly: true,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              //City
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: cityController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "City",
                    prefixIcon: Icon(
                      Icons.location_city,
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
                  readOnly: true,
                  maxLines: 3,
                  minLines: 1,
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
                  readOnly: true,
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: () => callProvider(widget.service.providerID),
      ),
    );
  }

  callProvider(String providerID) async {
    String phone = await getPhoneById(providerID);
    Uri phoneno = Uri.parse('tel:$phone');
    await launchUrl(phoneno);
  }
}
