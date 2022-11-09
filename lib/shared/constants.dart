import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

TextDirection rightToLeft = TextDirection.RTL;
TextDirection leftToRight = TextDirection.LTR;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final CollectionReference usersCollection = firebaseFirestore.collection('users');
final CollectionReference servicesCollection = firebaseFirestore.collection('services');
final CollectionReference citiesCollection = firebaseFirestore.collection('cities');
final CollectionReference categoriesCollection = firebaseFirestore.collection('categories');
