// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'voting_bloc.dart';

abstract class VotingEvent extends Equatable {
  const VotingEvent();

  @override
  List<Object> get props => [];
}

class CreateElection extends VotingEvent {
  final List<PlaceCandidate> candadates;
  const CreateElection({
    required this.candadates,
  });
  @override
  List<Object> get props => super.props..add(candadates);
}

class GenerateCandidates extends VotingEvent {
  final CurrentLocationParams currentLocation;
  const GenerateCandidates({
    required this.currentLocation,
  });
  @override
  List<Object> get props => super.props..add(currentLocation);
}

class FetchElectionResults extends VotingEvent {
  final String electionCode;
  const FetchElectionResults({
    required this.electionCode,
  });
}

class SubmitVote extends VotingEvent {
  final SubmitVoteParams vote;
  const SubmitVote({
    required this.vote,
  });

  @override
  List<Object> get props => super.props..add(vote);
}

class FetchCandidates extends VotingEvent {
  final String electionCode;
  const FetchCandidates({
    required this.electionCode,
  });

  @override
  List<Object> get props => super.props..add(electionCode);
}
