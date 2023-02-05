import 'package:dartz/dartz.dart';
import 'package:votepals/core/errors/failures.dart';
import 'package:votepals/core/mixins/repository_handler_mixin.dart';
import 'package:votepals/features/voting/data/datasources/voting_datasource.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';
import 'package:votepals/features/voting/domain/repositories/voting_repository.dart';

class VotingRepositoryImpl
    with RepositoryHandlerMixin
    implements VotingRepository {
  final VotingDataSource dataSource;

  const VotingRepositoryImpl({required this.dataSource});
  @override
  Future<Either<VotingFailure, String>> createElection(
      List<PlaceCandidate> candidates) {
    return this(
      request: () => dataSource.createElection(candidates),
      onFailure: (message) => VotingFailure(
        message: message ?? 'Something went wrong...',
      ),
    );
  }

  @override
  Future<Either<VotingFailure, List<PlaceCandidate>>> generateCandidates(
      CurrentLocationParams currentLocation) {
    return this(
      request: () => dataSource.generateCandidates(currentLocation),
      onFailure: (message) {
        return VotingFailure(message: message ?? 'Something went wrong...');
      },
    );
  }

  @override
  Future<Either<VotingFailure, Stream<List<PlaceCandidate>>>>
      fetchElectionResults(
    String electionCode,
  ) {
    return this(
      request: () async => dataSource.fetchElectionResults(electionCode),
      onFailure: (message) {
        return VotingFailure(message: message ?? 'Something went wrong...');
      },
    );
  }

  @override
  Future<Either<VotingFailure, List<PlaceCandidate>>> fetchCandidates(
      String electionCode) {
    return this(
      request: () async => dataSource.fetchCandidates(electionCode),
      onFailure: (message) {
        return VotingFailure(message: message ?? 'Something went wrong...');
      },
    );
  }

  @override
  Future<Either<VotingFailure, void>> submitVote(SubmitVoteParams params) {
    return this(
      request: () async => dataSource.submitVote(params),
      onFailure: (message) {
        return VotingFailure(message: message ?? 'Something went wrong...');
      },
    );
  }
}
