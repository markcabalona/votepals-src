// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'voting_bloc.dart';

abstract class VotingState extends Equatable {
  const VotingState();

  @override
  List<Object> get props => [];
}

class VotingInitial extends VotingState {}

class CreateElectionState extends VotingState {
  final StateStatus status;
  final List<PlaceCandidate> candidates;
  final String? electionCode;
  final String? message;
  const CreateElectionState({
    required this.status,
    required this.candidates,
    this.electionCode,
    this.message,
  });

  CreateElectionState copyWith({
    StateStatus? status,
    String? electionCode,
    List<PlaceCandidate>? candidates,
    String? message,
  }) {
    return CreateElectionState(
      status: status ?? this.status,
      electionCode: electionCode ?? this.electionCode,
      candidates: candidates ?? this.candidates,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      status,
      if (electionCode != null) electionCode!,
      if (message != null) message!,
    ]);
}

class GenerateCandidateState extends VotingState {
  final StateStatus status;
  final List<PlaceCandidate>? candidates;
  final String? message;
  const GenerateCandidateState({
    required this.status,
    this.candidates,
    this.message,
  });

  GenerateCandidateState copyWith({
    StateStatus? status,
    List<PlaceCandidate>? candidates,
    String? message,
  }) =>
      GenerateCandidateState(
        status: status ?? this.status,
        candidates: candidates ?? this.candidates,
        message: message ?? this.message,
      );
  @override
  List<Object> get props => super.props
    ..addAll([
      status,
      if (candidates != null) candidates!,
      if (message != null) message!,
    ]);
}

class ElectionResultsState extends VotingState {
  final StateStatus status;
  final Stream<List<PlaceCandidate>>? candidates;
  final String electionCode;
  final String? message;
  const ElectionResultsState({
    required this.status,
    required this.electionCode,
    this.candidates,
    this.message,
  });

  ElectionResultsState copyWith({
    StateStatus? status,
    Stream<List<PlaceCandidate>>? candidates,
    String? electionCode,
    String? message,
  }) =>
      ElectionResultsState(
        status: status ?? this.status,
        candidates: candidates ?? this.candidates,
        electionCode: electionCode ?? this.electionCode,
        message: message ?? this.message,
      );
  @override
  List<Object> get props => super.props
    ..addAll([
      status,
      if (candidates != null) candidates!,
      if (message != null) message!,
    ]);
}

class FetchCandidatesState extends VotingState {
  final StateStatus status;
  final List<PlaceCandidate>? candidates;
  final String electionCode;
  final String? message;
  const FetchCandidatesState({
    required this.status,
    required this.electionCode,
    this.candidates,
    this.message,
  });

  FetchCandidatesState copyWith({
    StateStatus? status,
    List<PlaceCandidate>? candidates,
    String? electionCode,
    String? message,
  }) =>
      FetchCandidatesState(
        status: status ?? this.status,
        electionCode: electionCode ?? this.electionCode,
        candidates: candidates ?? this.candidates,
        message: message ?? this.message,
      );
  @override
  List<Object> get props => super.props
    ..addAll([
      status,
      if (candidates != null) candidates!,
      if (message != null) message!,
    ]);
}

class SubmitVoteState extends VotingState {
  final StateStatus status;
  final List<PlaceCandidate>? candidates;
  final String electionCode;
  final String? message;
  const SubmitVoteState({
    required this.status,
    required this.electionCode,
    this.candidates,
    this.message,
  });

  SubmitVoteState copyWith({
    StateStatus? status,
    List<PlaceCandidate>? candidates,
    String? electionCode,
    String? message,
  }) =>
      SubmitVoteState(
        status: status ?? this.status,
        electionCode: electionCode ?? this.electionCode,
        candidates: candidates ?? this.candidates,
        message: message ?? this.message,
      );
  @override
  List<Object> get props => super.props
    ..addAll([
      status,
      if (candidates != null) candidates!,
      if (message != null) message!,
    ]);
}
