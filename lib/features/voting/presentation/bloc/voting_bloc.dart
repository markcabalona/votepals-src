// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:votepals/core/constants/enums.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/current_location_params.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';
import 'package:votepals/features/voting/domain/repositories/voting_repository.dart';

part 'voting_event.dart';
part 'voting_state.dart';

class VotingBloc extends Bloc<VotingEvent, VotingState> {
  final VotingRepository repository;
  VotingBloc({
    required this.repository,
  }) : super(VotingInitial()) {
    on<CreateElection>((event, emit) async {
      CreateElectionState createElectionState = CreateElectionState(
        status: StateStatus.loading,
        candidates: event.candadates,
      );

      emit(createElectionState);

      final result = await repository.createElection(event.candadates);

      result.fold(
        (l) => emit(
          createElectionState.copyWith(
            status: StateStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          createElectionState.copyWith(
            status: StateStatus.loaded,
            electionCode: r,
          ),
        ),
      );
    });
    on<GenerateCandidates>(
      (event, emit) async {
        emit(
          const GenerateCandidateState(status: StateStatus.loading),
        );
        final result =
            await repository.generateCandidates(event.currentLocation);

        result.fold(
          (l) => emit(
            (state as GenerateCandidateState).copyWith(
              status: StateStatus.error,
              message: l.message,
            ),
          ),
          (r) => emit(
            (state as GenerateCandidateState).copyWith(
              status: StateStatus.loaded,
              candidates: r,
            ),
          ),
        );
      },
    );
    on<FetchElectionResults>((event, emit) async {
      emit(ElectionResultsState(
        status: StateStatus.loading,
        electionCode: event.electionCode,
      ));
      final result = await repository.fetchElectionResults(event.electionCode);

      result.fold(
        (failure) => emit(
          (state as ElectionResultsState).copyWith(
            message: failure.message,
            status: StateStatus.error,
          ),
        ),
        (candidates) => emit(
          (state as ElectionResultsState).copyWith(
            candidates: candidates,
            status: StateStatus.loaded,
          ),
        ),
      );
    });

    on<SubmitVote>((event, emit) async {
      log("submitting");
      SubmitVoteState currentState = SubmitVoteState(
        status: StateStatus.loading,
        candidates: event.vote.candidates,
        electionCode: event.vote.electionCode,
      );
      emit(currentState);

      final result = await repository.submitVote(event.vote);

      result.fold(
        (l) => emit(currentState.copyWith(
          message: l.message,
          status: StateStatus.error,
        )),
        (r) => emit(currentState.copyWith(
          status: StateStatus.loaded,
        )),
      );
    });

    on<FetchCandidates>((event, emit) async {
      final currentState = FetchCandidatesState(
        status: StateStatus.loading,
        electionCode: event.electionCode,
      );
      emit(currentState);
      final result = await repository.fetchCandidates(event.electionCode);

      result.fold(
        (l) => emit(currentState.copyWith(
          message: l.message,
          status: StateStatus.error,
        )),
        (r) => emit(currentState.copyWith(
          candidates: r,
          status: StateStatus.loaded,
        )),
      );
    });
  }
}
