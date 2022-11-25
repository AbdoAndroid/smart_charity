import 'package:flutter/material.dart';
import 'package:smart_charity/model/donation.dart';
import 'package:smart_charity/service/auth.dart';
import 'package:smart_charity/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/donations.dart';

class ViewDonation extends StatefulWidget {
  const ViewDonation({Key? key, required this.donation}) : super(key: key);
  final Donation donation;
  @override
  State<ViewDonation> createState() => _ViewDonationState();
}

class _ViewDonationState extends State<ViewDonation> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController donorController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categoryController =
        TextEditingController(text: categories[widget.donation.category]);
    descriptionController =
        TextEditingController(text: widget.donation.description);
    cityController =
        TextEditingController(text: widget.donation.city.toString());
    _initDonorAndPhone();
  }

  _initDonorAndPhone() async {
    String _name = await getNameByUsername(widget.donation.donorID);
    String _phone = await getPhoneByUsername(widget.donation.donorID);
    setState(() {
      donorController.text = _name;
      phoneController.text = _phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Donation details'),
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
                  controller: donorController,
                  readOnly: true,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Donor: ",
                    prefixIcon: Icon(
                      Icons.person,
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
                  controller: phoneController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    prefixIcon: Icon(
                      Icons.call,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Visibility(
                visible: widget.donation.status == 1 && currentUser!.isCharity,
                child: ElevatedButton(
                  child: Text('Set ad delivered'),
                  onPressed: () {
                    setDelivered();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: currentUser!.isCharity
          ? FloatingActionButton(
              child: Icon(Icons.call),
              onPressed: () => callProvider(widget.donation.donorID),
            )
          : null,
    );
  }

  setDelivered() async {
    await changeStatus(widget.donation.id, 2);
    setState(() {
      widget.donation.status = 2;
    });
  }

  callProvider(String donorID) async {
    //String phone = await getPhoneByUsername(donorID);
    Uri phoneno = Uri.parse('tel:${phoneController.text}');
    await launchUrl(phoneno);
    await changeStatus(widget.donation.id, 1);
    setState(() {
      widget.donation.status = 1;
    });
  }
}
