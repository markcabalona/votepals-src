// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/enums.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/utils/launch_url.dart';
import 'package:votepals/core/utils/state_indicators/state_indicators.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';
import 'package:votepals/features/voting/presentation/bloc/geolocator_bloc.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';
import 'package:votepals/features/voting/presentation/widgets/election_code_dialog.dart';

class NewVotingScreen extends StatelessWidget {
  const NewVotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (BlocInstances.geolocatorBloc.state is! LocationLoaded) {
      BlocInstances.geolocatorBloc.add(FetchCurrentLocation());
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<GeolocatorBloc, GeolocatorState>(
          listener: (context, state) {
            if (state is LoadingLocation) {
              showLoading('Getting current location');
            }
            if (state is LocationError) {
              showError(state.message);
            }
            if (state is LocationLoaded) {
              EasyLoading.dismiss();
              BlocInstances.votingBloc.add(
                GenerateCandidates(
                  currentLocation: state.currentLocation,
                ),
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated && state.shouldRedirect) {
              if (AppRouter.router.canPop()) {
                return;
              } else {
                AppRouter.router.goNamed(
                  state.routeName!,
                  params: state.params,
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<VotingBloc, VotingState>(
        buildWhen: (previous, current) {
          if (current is CreateElectionState && current.electionCode != null) {
            // showLoading(current.electionCode!);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ElectionCodeDialog(
                  electionCode: current.electionCode!,
                );
              },
            );
          }

          return current is GenerateCandidateState;
        },
        builder: (context, state) {
          if (state is GenerateCandidateState) {
            if (state.status == StateStatus.loading) {
              showLoading('Loading nearby tourist attractions');
              return Container();
            } else if (state.status == StateStatus.error) {
              EasyLoading.dismiss();
              return Center(
                child: Text(state.message ?? 'Failed to load places'),
              );
            }
            EasyLoading.dismiss();
            showSuccess('10 Tourist Attractions Generated Successfully');

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: CustomPaddings.large * 1.5),
                        child: GeneratedCandidatesTable(
                          candidates: state.candidates ?? [],
                        ),
                      ),
                    ),
                    VerticalSpacers.medium,
                    SizedBox(
                      width: 200,
                      child: TextButton(
                        onPressed: state is CreateElectionState &&
                                (state.status == StateStatus.loading)
                            ? null
                            : () {
                                BlocInstances.votingBloc.add(CreateElection(
                                    candadates: state.candidates!));
                              },
                        child: const Text("Create Election"),
                      ),
                    ),
                    VerticalSpacers.medium,
                  ],
                ),
              ),
            );
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      state.candidates!.length,
                      (index) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            final lat = state.candidates![index].latitude;
                            final long = state.candidates![index].longitude;
                            // launchUrl(
                            //   Uri.parse(
                            //     'https://www.google.com/maps/search/$lat,$long/@$lat,$long,17z',
                            //   ),
                            // );
                            customLaunchUrl(
                              'https://www.google.com/search?q=${state.candidates![index].formattedAddress}',
                            );
                          },
                          child: Text(
                            '${index + 1}.) ${state.candidates![index].name}',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    VerticalSpacers.medium,
                    SizedBox(
                      width: 200,
                      child: TextButton(
                        onPressed: state is CreateElectionState &&
                                (state.status == StateStatus.loading)
                            ? null
                            : () {
                                BlocInstances.votingBloc.add(CreateElection(
                                    candadates: state.candidates!));
                              },
                        child: const Text("Create Election"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class GeneratedCandidatesTable extends StatelessWidget {
  const GeneratedCandidatesTable({
    Key? key,
    required this.candidates,
  }) : super(key: key);
  final List<PlaceCandidate> candidates;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('City'),
        ),
      ],
      rows: _buildRows(),
    );
  }

  List<DataRow> _buildRows() {
    return List<DataRow>.generate(
      candidates.length,
      (index) => DataRow(
        cells: [
          DataCell(Text(candidates[index].name)),
          DataCell(Text(candidates[index].city)),
        ],
      ),
    );
  }
}
