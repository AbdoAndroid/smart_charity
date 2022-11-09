import 'package:smart_charity/model/user.dart';

class Service {
  late String id;
  late String description;
  late String category;
  late String providerID;
  User? provider;
  Offer? offer;
  late bool hasOffer;
  String city;
  String fullAddress;
  double price;
  Service({
    required this.id,
    required this.description,
    required this.category,
    required this.providerID,
    this.provider,
    this.offer,
    required this.hasOffer,
    required this.city,
    required this.fullAddress,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'providerID': providerID,
      'offer': offer?.toMap(),
      'hasOffer': hasOffer,
      'city': city,
      'fullAddress': fullAddress,
      'price': price,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    Service s = Service(
      id: map['id'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      providerID: map['providerID'] as String,
      hasOffer: map['hasOffer'] as bool,
      city: map['city'] as String,
      fullAddress: map['fullAddress'] as String,
      price: map['price'] as double,
    );
    if (s.hasOffer) {
      s.offer = Offer.fromMap(map['offer'] as Map<String, dynamic>);
    }
    return s;
  }
}

class Offer {
  late String id;
  late double value;
  DateTime? startDate;
  DateTime? endDate;

  Offer.name({required this.id, required this.value, this.startDate, this.endDate});

  Offer(this.id, this.value, this.startDate, this.endDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer.name(
      id: map['id'] as String,
      value: map['value'] as double,
      startDate: map['startDate'] as DateTime,
      endDate: map['endDate'] as DateTime,
    );
  }
}
