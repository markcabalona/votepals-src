// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/enums.dart';
import 'package:votepals/core/presentation/widgets/redirect_to_home_dialog.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/utils/state_indicators/state_indicators.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';
import 'package:votepals/features/voting/presentation/widgets/vote_recorded_dialog.dart';
import 'package:votepals/features/voting/presentation/widgets/voting_form.dart';

class SubmitVotePage extends StatelessWidget {
  const SubmitVotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final votingBloc = BlocInstances.votingBloc;
    final electionCode = AppRouter.router.location.split('/').last;

    if (votingBloc.state is FetchCandidatesState &&
        (votingBloc.state as FetchCandidatesState).electionCode ==
            electionCode) {
    } else {
      votingBloc.add(FetchCandidates(electionCode: electionCode));
    }

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RedirectToHomeDialog(
            text:
                'Sorry, you are not allowed to visit this page. You must log in before you can go to this page.',
          ),
        );
      });
      return const SizedBox();
    }

    return BlocBuilder<VotingBloc, VotingState>(
      buildWhen: (previous, current) {
        log(current.toString());
        if (current is! SubmitVoteState) {
          return true;
        }
        if (current.status == StateStatus.loading) {
          showLoading('Submitting your vote...');
        } else if (current.status == StateStatus.error) {
          showError(current.message ?? 'Failed to submit your vote.');
        } else {
          EasyLoading.dismiss();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return VoteRecordedDialog(
                electionCode: current.electionCode,
              );
            },
          );
        }
        return false;
      },
      builder: (context, state) {
        if (state is! FetchCandidatesState) {
          return const Center(
            child: Text("Please Wait.."),
          );
        }
        if (state.status == StateStatus.loading) {
          showLoading('Loading candidates for election `$electionCode`');
          return Container();
        } else if (state.status == StateStatus.error) {
          EasyLoading.dismiss();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => RedirectToHomeDialog(
                text: state.message ?? 'Failed to load candidates.',
                textAlign: TextAlign.center,
              ),
            );
          });
          return const SizedBox();
        }
        EasyLoading.dismiss();

        return Center(
          child: VotingForm(
            candidates: state.candidates ?? [],
            electionCode: state.electionCode,
          ),
        );
      },
    );
  }
}
