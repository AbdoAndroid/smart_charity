import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_charity/model/user.dart';

class Donation {
  String id;
  String description;
  int category;
  String donorID;
  User? donor;
  String charityID;
  User? charity;
  City city;
  int status;
  Donation(
      {required this.id,
      required this.description,
      required this.category,
      required this.donorID,
      this.donor,
      required this.city,
      required this.status,
      required this.charityID,
      this.charity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'donorID': donorID,
      'city': city.toString(),
      'status': status,
      'charityID': charityID,
    };
  }

  factory Donation.fromSnapshot(DocumentSnapshot snapshot) {
    Donation d = Donation.fromMap(snapshot.data() as Map<String, dynamic>);
    d.id = snapshot.id;
    return d;
  }
  factory Donation.fromMap(Map<String, dynamic> map) {
    Donation d = Donation(
      id: map['id'] as String,
      description: map['description'] as String,
      category: map['category'] as int,
      donorID: map['donorID'] as String,
      status: map['status'] as int,
      charityID: map['charityID'] as String,
      city: City(map['city'] as String),
    );
    return d;
  }
}

class City {
  String name;

  City(this.name);

  Map<String, dynamic> toMap() {
    return {'name': this.name};
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(map['name'] as String);
  }

  @override
  String toString() => name;
}
