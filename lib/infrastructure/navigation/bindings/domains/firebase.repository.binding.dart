import 'package:cloud_firestore/cloud_firestore.dart';

import '/domain/firebase/firebase.repository.dart';
import '../../../dal/services/firebase/firebase.service.dart';

class FirebaseRepositoryBinding {
  late FirebaseRepository _firebaseRepository;

  FirebaseRepository get repository => _firebaseRepository;

  FirebaseRepositoryBinding() {
    final connect = FirebaseFirestore.instance;
    final firebaseService = FirebaseService(connect);
    _firebaseRepository = FirebaseRepository(firebaseService: firebaseService);
  }
}
