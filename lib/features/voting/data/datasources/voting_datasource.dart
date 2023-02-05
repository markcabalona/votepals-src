import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';

abstract class VotingDataSource {
  Future<String> createElection(List<PlaceCandidate> candidates);
  Future<Stream<List<PlaceCandidate>>> fetchElectionResults(
      String electionCode);
  Future<List<PlaceCandidate>> generateCandidates(
    CurrentLocationParams currentLocation,
  );
  Future<List<PlaceCandidate>> fetchCandidates(String electionCode);
  Future<void> submitVote(SubmitVoteParams params);
}
