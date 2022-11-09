import '../model/service.dart';
import '../shared/constants.dart';
import 'auth.dart';

Future<List<Service>> getAllServicesForProvider() async {
  List<Service> lst = [];
  var output = await servicesCollection.where("providerID", isEqualTo: currentUser!.id).get();
  for (var element in output.docs) {
    Service srv = Service.fromMap(element.data() as Map<String, dynamic>);
    srv.provider = await getUserById(srv.providerID);
    lst.add(srv);
  }
  return lst;
}

Future<List<Service>> getAllServicesByCity(String city) async {
  List<Service> lst = [];
  var output;
  if (city != "All cities") {
    output = await servicesCollection.where("city", isEqualTo: city).get();
  } else {
    output = await servicesCollection.get();
  }
  for (var element in output.docs) {
    Service srv = Service.fromMap(element.data() as Map<String, dynamic>);
    srv.provider = await getUserById(srv.providerID);
    lst.add(srv);
  }
  return lst;
}

addService(Service service) async {
  await servicesCollection.add(service.toMap());
}

Future<List<String>> getCities({bool forSearch = false}) async {
  List<String> cities = forSearch ? ['All cities'] : [];
  var output = await citiesCollection.get();
  output.docs.forEach((element) {
    cities.add((element.data() as Map<String, dynamic>)['name']);
  });
  return cities;
}

Future<List<String>> getCategories() async {
  List<String> cities = [];
  var output = await categoriesCollection.get();
  output.docs.forEach((element) {
    cities.add((element.data() as Map<String, dynamic>)['name']);
  });
  return cities;
}
