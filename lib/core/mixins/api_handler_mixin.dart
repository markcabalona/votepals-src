import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:votepals/core/utils/generate_random_string.dart';

mixin APIHandlerMixin {
  final Dio dio = Dio();
  Future<ReturnType> dioHandler<ReturnType>({
    required Future<ReturnType> Function() request,
    required dynamic Function(DioError error) onFailure,
  }) async {
    try {
      return request();
    } on DioError catch (e) {
      return onFailure(e);
    } catch (e) {
      log(name: 'APIHandlerMixin: ', e.toString());
      rethrow;
    }
  }
}

mixin FirestoreHandlerMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<ReturnType> firestoreHandler<ReturnType>({
    required Future<ReturnType> Function() request,
    required dynamic Function(FirebaseException error) onFailure,
  }) async {
    try {
      return request();
    } on FirebaseException catch (e) {
      return onFailure(e);
    } catch (e) {
      log(name: 'FirebaseHandlerMixin: ', e.toString());
      rethrow;
    }
  }

  Future<String> generateElectionID() async {
    final String newElectionID = getRandomString(6);
    log(newElectionID);

    final electionRef = firestore.collection('elections').doc(newElectionID);

    log(electionRef.toString());

    final doc = await electionRef.get();
    
    if (doc.exists) {
      return generateElectionID();
    } else {
      return newElectionID;
    }
  }
}
