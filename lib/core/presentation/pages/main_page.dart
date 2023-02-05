import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/presentation/widgets/dynamic_title_header.dart';
import 'package:votepals/core/presentation/widgets/election_code_form.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/core/themes/custom_colors.dart';
import 'package:votepals/core/utils/state_indicators/state_indicators.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:votepals/features/voting/presentation/bloc/geolocator_bloc.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CustomPaddings.large,
            vertical: CustomPaddings.medium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacers.xxxLarge,
              const DynamictTitleHeader(),
              Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: "It's a ",
                    ),
                    TextSpan(
                      text: 'voting ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: 'adventure.',
                    ),
                  ],
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: CustomColors.primary),
              ),
              Text(
                'A travel destination voting system using Borda Count.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: CustomColors.dark),
              ),
              VerticalSpacers.xxxLarge,
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
                    context.pushNamed(Routes.createElection.name);
                  }
                },
                child: TextButton(
                  onPressed: () {
                    BlocInstances.geolocatorBloc.add(
                      FetchCurrentLocation(),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.ballot,
                        color: CustomColors.white,
                        size: 24,
                      ),
                      HorizontalSpacers.medium,
                      Text("Create new election"),
                    ],
                  ),
                ),
              ),
              VerticalSpacers.medium,
              const SizedBox(
                width: 500,
                child: ElectionCodeForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicActionButton extends StatelessWidget {
  const DynamicActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is Authenticated;
        return TextButton(
          onPressed: () {
            final bloc = BlocProvider.of<AuthBloc>(context);
            if (isAuthenticated) {
              bloc.add(Logout());
            } else {
              bloc.add(SignInWithGoogle());
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: CustomColors.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isAuthenticated ? 'Logout' : 'Login',
              ),
              HorizontalSpacers.small,
              Icon(
                isAuthenticated ? Icons.logout_rounded : Icons.login,
                color: CustomColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
