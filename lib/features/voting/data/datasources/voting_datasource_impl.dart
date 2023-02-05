import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:votepals/core/errors/exceptions.dart';
import 'package:votepals/core/mixins/api_handler_mixin.dart';
import 'package:votepals/core/mixins/secrets_mixin.dart';
import 'package:votepals/features/voting/data/datasources/voting_datasource.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';

class VotingDataSourceImpl
    with APIHandlerMixin, SecretsMixin, FirestoreHandlerMixin
    implements VotingDataSource {
  @override
  Future<String> createElection(List<PlaceCandidate> candidates) {
    return firestoreHandler(
      request: () async {
        CollectionReference elections = firestore.collection('elections');

        final electionID = await generateElectionID();

        final DocumentReference newElection = elections.doc(electionID);
        await newElection.set({
          "voters": <String>[],
          "date_created": DateTime.now().millisecondsSinceEpoch,
          "valid_until": DateTime.now()
              .add(const Duration(minutes: 30))
              .millisecondsSinceEpoch,
        });

        final newElectionCandidates = firestore
            .collection('elections')
            .doc(newElection.id)
            .collection('candidates');

        for (var element in candidates) {
          newElectionCandidates.add(element.toMap());
        }

        return newElection.id;

        // throw UnimplementedError();
      },
      onFailure: (error) {
        log(error: 'Firestore Error', error.message ?? 'No error message');
        throw VotingException(
          message: error.message,
        );
      },
    );
  }

  @override
  Future<Stream<List<PlaceCandidate>>> fetchElectionResults(
      String electionCode) {
    return firestoreHandler(
      request: () async {
        final DocumentReference election =
            firestore.collection('elections').doc(electionCode);

        final isValid =
            (await election.collection('candidates').get()).docs.isNotEmpty;
        if (!isValid) {
          log(electionCode);
          log(isValid.toString());
          final candidates =
              (await election.collection('candidates').get()).docs;

          log(candidates.toString());
          throw VotingException(
            message: 'Election Code `$electionCode` do not exists',
          );
        }

        final List<dynamic> voters = ((await election.get()).data()
                as Map<dynamic, dynamic>?)?['voters'] ??
            <dynamic>[];

        if (!voters.contains(FirebaseAuth.instance.currentUser!.email)) {
          throw VotingException(
            message: 'You must submit a vote first to see the results.',
          );
        }

        final candidatesSnapShots =
            election.collection('candidates').snapshots();

        return candidatesSnapShots.map((event) {
          return event.docs
              .map(
                (e) => PlaceCandidate.fromMap(
                    e.data()..addEntries({'id': e.id}.entries)),
              )
              .toList();
        });

        // return candidatesSnapShots.cast<PlaceCandidate>();

        // log(candidates.toString());

        // return candidates
        //     .map(
        //       (e) => PlaceCandidate.fromMap(
        //           e.data()..addEntries({'id': e.id}.entries)),
        //     )
        //     .toList();

        // throw UnimplementedError();
      },
      onFailure: (error) {
        log(error: 'Firestore Error', error.message ?? 'No error message');
        throw VotingException(
          message: error.message,
        );
      },
    );
  }

  @override
  Future<List<PlaceCandidate>> fetchCandidates(String electionCode) {
    return firestoreHandler(
      request: () async {
        final DocumentReference election =
            firestore.collection('elections').doc(electionCode);

        final candidates = (await election.collection('candidates').get()).docs;

        final isValid = candidates.isNotEmpty;

        if (!isValid) {
          throw VotingException(
            message: 'Election Code `$electionCode` do not exists',
          );
        }
        final electionDoc = await election.get();

        final List<dynamic> voters =
            (electionDoc.data() as Map<dynamic, dynamic>?)?['voters'] ??
                <dynamic>[];

        final validUntil =
            (electionDoc.data() as Map<dynamic, dynamic>?)?['valid_until'];

        final isVotingPeriodDone =
            (DateTime.fromMillisecondsSinceEpoch(validUntil))
                    .difference(DateTime.now())
                    .inMilliseconds >=
                0;

        if (!isVotingPeriodDone) {
          throw VotingException(
            message: 'Voting period for election `$electionCode` has ended.',
          );
        }

        final alreadyVoted = voters.contains(
          FirebaseAuth.instance.currentUser!.email,
        );

        if (alreadyVoted) {
          throw VotingException(
            message: 'You have already voted for election `$electionCode`',
          );
        }

        return candidates
            .map(
              (e) => PlaceCandidate.fromMap(
                  e.data()..addEntries({'id': e.id}.entries)),
            )
            .toList();
      },
      onFailure: (error) {
        log(error: 'Firestore Error', error.message ?? 'No error message');
        throw VotingException(
          message: error.message,
        );
      },
    );
  }

  @override
  Future<List<PlaceCandidate>> generateCandidates(
    CurrentLocationParams currentLocation,
  ) {
    return dioHandler(
      request: () async {
        if (kDebugMode) {
          final List<Map<String, dynamic>> names = [
            {
              'name': 'Jhon Monument',
              'formatted':
                  'jhon monument, Gideon, Caloocan, 1420 Metro Manila, Philippines',
              'lon': 121.0217932,
              'lat': 14.7254339,
              'city': 'Caloocan',
            },
            {
              'name': 'Sta. Lucia Arko',
              'formatted':
                  'Sta. Lucia Arko, Quezon City, 1100 Metro Manila, Philippines',
              'lon': 121.055785,
              'lat': 14.7046609,
              'city': 'Quezon City',
            },
            {
              'name': 'Florentino S. Dulalia, Sr.',
              'formatted':
                  'Florentino S. Dulalia, Sr., P. Gregorio Street, Valenzuela, 1446 Metro Manila, Philippines',
              'lon': 120.9754279,
              'lat': 14.7202646,
              'city': 'Valenzuela',
            },
            {
              'name': 'Tandang Sora Memorial Shrine',
              'formatted':
                  'Tandang Sora Memorial Shrine, Road 7, Quezon City, 1107 Metro Manila, Philippines',
              'lon': 121.0534738,
              'lat': 14.6841819,
              'city': 'Quezon City',
            },
            {
              'name': 'Emilio Jacinto Shrine',
              "lon": 121.0509364,
              "lat": 14.6809801,
              "formatted":
                  "Emilio Jacinto Shrine, Road 3, Quezon City, 1107 Metro Manila, Philippines",
              'city': 'Quezon City',
            },
            {
              'name': 'San Isidro Chapel',
              "lon": 121.0577575,
              "lat": 14.7691935,
              "formatted":
                  "San Isdro Chapel, Langit Road, Caloocan, 1438 Metro Manila, Philippines",
              'city': 'Caloocan',
            },
            {
              "name":
                  "Monument to Unknown Guerilla Shot While Raising the Flag",
              "city": "Meycauayan",
              "lon": 120.9731942,
              "lat": 14.7472763,
              "formatted":
                  "Monument to Unknown Guerilla Shot While Raising the Flag, Malhacan-Libtong Road, Meycauayan, 3020 Bulacan, Philippines",
            },
            {
              "name": "Kilometer 14",
              "city": "Quezon City",
              "lon": 121.0427541,
              "lat": 14.6716774,
              "formatted":
                  "Kilometer 14, Congressional Avenue, Quezon City, 1107 Metro Manila, Philippines",
            },
            {
              "name": null,
              "city": "Valenzuela",
              "lon": 120.9759997,
              "lat": 14.6949199,
              "formatted":
                  "NLEX Harbor Link Segment 10, Valenzuela, 0550 Metro Manila, Philippines",
            },
            {
              "name": 'Kilometer 13',
              "city": "Quezon City",
              "lon": 121.0341753,
              "lat": 14.6683639,
              "formatted":
                  "Kilometer 13, Congressional Avenue, Quezon City, 1106 Metro Manila, Philippines",
            },
          ];
          return names.map((e) => PlaceCandidate.fromMap(e)).toList();
        }

        final response = await dio.get(
          '$geoApiHost/places?categories=entertainment,national_park,camping,leisure,tourism.sights&filter=circle:${currentLocation.longitude},${currentLocation.latitude},10000&bias=proximity:${currentLocation.longitude},${currentLocation.latitude}&limit=20&apiKey=$geoApiKey',
        );

        if (response.statusCode == 200) {
          final places = (response.data['features'] as List<dynamic>);
          places.shuffle();

          final filteredPlaces = places
              .where((element) =>
                  element['properties']['name'] != null ||
                  element['properties']['formatted'] != null ||
                  element['properties']['suburb'] != null)
              .toList();
          final placeCandidates = filteredPlaces.length > 10
              ? filteredPlaces.take(10)
              : filteredPlaces;

          return (placeCandidates).map(
            (feature) {
              return PlaceCandidate.fromMap(feature['properties']);
            },
          ).toList();
        }
        return [];
      },
      onFailure: (error) {
        throw VotingException(
          message: error.message,
        );
      },
    );
  }

  @override
  Future<void> submitVote(SubmitVoteParams params) {
    return firestoreHandler(
      request: () async {
        final electionRef =
            firestore.collection('elections').doc(params.electionCode);

        final candidates = electionRef.collection('candidates');

        for (var i = 0; i < params.candidates.length; i++) {
          final cand = params.candidates[i];
          final docRef = candidates.doc(cand.id);

          await firestore.runTransaction(
            (transaction) async {
              final doc = await docRef.get();
              final int currentVoteCount =
                  doc.data()?['vote_count'] ?? cand.voteCount;

              final int voteCount =
                  currentVoteCount + params.candidates.length - i;
              log('$voteCount | $currentVoteCount | ${params.candidates.length - i}');
              transaction.update(
                docRef,
                {
                  'vote_count': voteCount,
                },
              );
            },
          );
        }
        await firestore.runTransaction((transaction) async {
          final electionDoc = await electionRef.get();
          final voters = electionDoc.data()?['voters'] ?? [];
          transaction.update(electionRef, {
            'voters': voters..add(FirebaseAuth.instance.currentUser!.email!),
          });
        });
      },
      onFailure: (error) {
        throw VotingException(
          message: error.message,
        );
      },
    );
  }
}
