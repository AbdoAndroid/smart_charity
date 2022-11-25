import '../model/donation.dart';
import '../shared/constants.dart';
import 'auth.dart';

addDonation(Donation don) async {
  await donationsCollection.add(don.toMap());
}

Future<List<String>> getCities({bool forSearch = false}) async {
  List<String> cities = forSearch ? ['All cities'] : [];
  var output = await citiesCollection.get();
  output.docs.forEach((element) {
    cities.add((element.data() as Map<String, dynamic>)['name']);
  });
  return cities;
}

Future<List<Donation>> getDonorDonations(int status) async {
  List<Donation> donations = [];
  var output = await donationsCollection.where('donorID',
      isEqualTo: currentUser!.username);
  if (status == 2) {
    output = output.where('status', isEqualTo: 2);
  } else {
    output = output.where('status', isLessThan: 2);
  }
  var snap = await output.get();
  snap.docs.forEach((element) async {
    Donation don = Donation.fromSnapshot(element);
    donations.add(don);
  });
  return donations;
}

changeStatus(String id, int status) async {
  donationsCollection.doc(id).update({'status': status});
}

Future<List<Donation>> getCharityDonations(int status) async {
  List<Donation> donations = [];
  var output = await donationsCollection
      .where('charityID', isEqualTo: currentUser!.username)
      .where('status', isEqualTo: status)
      .get();
  output.docs.forEach((element) async {
    Donation don = Donation.fromSnapshot(element);
    donations.add(don);
  });
  return donations;
}

Future<List<Donation>> getCharityDonationsByCityAndCategory(
    int cat, String city) async {
  List<Donation> donations = await getCharityDonations(0);
  List<Donation> outDonations = [];
  donations.forEach((element) {
    if ((city == 'All cities' || city == element.city.toString()) &&
        (cat == 0 || cat - 1 == element.category)) {
      outDonations.add(element);
    }
  });
  return outDonations;
}
