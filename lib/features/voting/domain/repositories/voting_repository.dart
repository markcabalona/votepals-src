import 'package:dartz/dartz.dart';
import 'package:votepals/core/errors/failures.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';

abstract class VotingRepository {
  Future<Either<VotingFailure, String>> createElection(
    List<PlaceCandidate> candidates,
  );
  Future<Either<VotingFailure, Stream<List<PlaceCandidate>>>> fetchElectionResults(
      String electionCode);
  Future<Either<VotingFailure, List<PlaceCandidate>>> generateCandidates(
    CurrentLocationParams currentLocation,
  );
  Future<Either<VotingFailure, void>> submitVote(SubmitVoteParams params);
  Future<Either<VotingFailure, List<PlaceCandidate>>> fetchCandidates(
    String electionCode,
  );
}
