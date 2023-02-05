// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/enums.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/constants/ranks.dart';
import 'package:votepals/core/presentation/widgets/redirect_to_home_dialog.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/utils/state_indicators/state_indicators.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';

class VPResultPage extends StatelessWidget {
  const VPResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final votingBloc = BlocInstances.votingBloc;
    final electionCode = AppRouter.router.location.split('/').last;

    if (votingBloc.state is ElectionResultsState &&
        (votingBloc.state as ElectionResultsState).electionCode ==
            electionCode) {
    } else {
      BlocInstances.votingBloc.add(
        FetchElectionResults(
          electionCode: electionCode,
        ),
      );
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
      builder: (context, state) {
        log(state.toString());
        if (state is! ElectionResultsState) {
          return const Center(
            child: Text("Please Wait.."),
          );
        }
        if (state.status == StateStatus.loading) {
          showLoading('Loading result for election `$electionCode`');
          return Container();
        } else if (state.status == StateStatus.error) {
          EasyLoading.dismiss();
          return Center(
            child: Text(state.message ?? 'Failed to load places'),
          );
        }
        EasyLoading.dismiss();

        return SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacers.xxxLarge,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomPaddings.medium,
                ),
                child: AutoSizeText(
                  'NOTE: TIES WILL BE RANKED THE SAME',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              VerticalSpacers.large,
              StreamBuilder(
                  stream: state.candidates,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      showLoading('Loading results...');
                      return const SizedBox();
                    }
                    if (snapshot.hasData) {
                      snapshot.data!.sort(
                        (a, b) => b.voteCount! - a.voteCount!,
                      );
                      EasyLoading.dismiss();

                      return Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: CustomPaddings.large * 1.5),
                            child: VotingResultChart(
                              candidates: snapshot.data!,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(state.message ?? 'Failed to load places'),
                      );
                    }
                    return const SizedBox();
                  }),
            ],
          ),
        );
      },
    );
  }
}

class VotingResultChart extends StatefulWidget {
  const VotingResultChart({
    Key? key,
    required this.candidates,
  }) : super(key: key);
  final List<PlaceCandidate> candidates;

  @override
  State<VotingResultChart> createState() => _VotingResultChartState();
}

class _VotingResultChartState extends State<VotingResultChart> {
  final List<String> placeRanks = [];

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Rank'),
        ),
        DataColumn(
          label: Text('Name'),
        ),
      ],
      rows: _buildRows(),
    );
  }

  List<DataRow> _buildRows() {
    _buildRanks();
    return List<DataRow>.generate(
      widget.candidates.length,
      (index) => DataRow(
        cells: [
          DataCell(Text(placeRanks[index])),
          DataCell(Text(widget.candidates[index].name)),
        ],
      ),
    );
  }

  void _buildRanks() {
    placeRanks.clear();
    for (int i = 0, rankIndex = 0; i < widget.candidates.length; rankIndex++) {
      final nextCandidateIndex = i + 1;
      final candidate = widget.candidates[i];

      if (nextCandidateIndex == widget.candidates.length) {
        placeRanks.add(ranks[rankIndex] ?? 'Unranked');
      }

      final voteCount = candidate.voteCount ?? 0;

      final ties =
          widget.candidates.where((element) => element.voteCount == voteCount);

      for (var _ in ties) {
        placeRanks.add(ranks[rankIndex] ?? 'Unranked');
      }
      i = widget.candidates.indexOf(ties.last) + 1;
    }
  }
}
