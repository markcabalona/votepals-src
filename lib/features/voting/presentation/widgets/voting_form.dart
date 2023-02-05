import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/constants/ranks.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/domain/params/submit_vote_params.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';
import 'package:votepals/features/voting/presentation/widgets/place_candidate_widget.dart';

class VotingForm extends StatefulWidget {
  const VotingForm({
    Key? key,
    required this.candidates,
    required this.electionCode,
  }) : super(key: key);
  final List<PlaceCandidate> candidates;
  final String electionCode;

  @override
  State<VotingForm> createState() => _VotingFormState();
}

class _VotingFormState extends State<VotingForm> {
  
  late final List<PlaceCandidate> candidates;

  PointerDeviceKind pointerKind = PointerDeviceKind.touch;

  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();
    candidates = widget.candidates;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _setPointerKind(event.kind);
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ReorderableColumn(
          header: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VerticalSpacers.xxLarge,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomPaddings.medium,
                ),
                child: Text(
                  '${_getVotingDirections()} and rearrange the candidates based on your preferred order. 1st candidate will receive the highest points (10 pts) and the 10th candidate will receive the lowest points (1 pt)',
                ),
              ),
              VerticalSpacers.large,
            ],
          ),
          footer: Center(
            child: Column(
              children: [
                VerticalSpacers.medium,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              setState(() {
                                isSubmitting = true;
                                BlocInstances.votingBloc.add(
                                  SubmitVote(
                                    vote: SubmitVoteParams(
                                      electionCode: widget.electionCode,
                                      candidates: candidates,
                                    ),
                                  ),
                                );
                              });
                            },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
                VerticalSpacers.xLarge,
              ],
            ),
          ),
          crossAxisAlignment: CrossAxisAlignment.start,
          needsLongPressDraggable: pointerKind == PointerDeviceKind.touch,
          onReorder: _onReorder,
          children: List.generate(
            candidates.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CustomPaddings.medium,
                vertical: CustomPaddings.large,
              ),
              key: ValueKey(candidates[index].hashCode),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.drag_indicator_rounded),
                  HorizontalSpacers.medium,
                  Text(
                    "${ranks[index]}",
                  ),
                  HorizontalSpacers.medium,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showDetails(candidates[index]);
                      },
                      child: AutoSizeText(
                        candidates[index].name,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      PlaceCandidate row = candidates.removeAt(oldIndex);
      candidates.insert(newIndex, row);
    });
  }

  void _showDetails(PlaceCandidate candidate) {
    showDialog(
      context: context,
      builder: (context) {
        return PlaceCandidateWidget(
          candidate: candidate,
        );
      },
    );
  }

  void _setPointerKind(PointerDeviceKind kind) {
    if (pointerKind == kind) return;

    setState(() {
      pointerKind = kind;
    });
  }

  String _getVotingDirections() {
    if (pointerKind == PointerDeviceKind.touch) {
      return 'Press and hold a tile until it pops';
    }
    return 'Drag a tile';
  }
}
