import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/core/themes/custom_colors.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';

class ElectionCodeForm extends StatefulWidget {
  const ElectionCodeForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ElectionCodeForm> createState() => _ElectionCodeFormState();
}

class _ElectionCodeFormState extends State<ElectionCodeForm> {
  final formKey = GlobalKey<FormState>();
  final codeCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: codeCtrl,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an election code';
              }
              return null;
            },
            cursorColor: CustomColors.white,
            decoration: const InputDecoration(
              hintText: 'Enter code',
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: CustomPaddings.large,
                  right: CustomPaddings.medium,
                  bottom: CustomPaddings.small / 2,
                ),
                child: Icon(
                  Icons.keyboard_alt_rounded,
                  size: 24,
                ),
              ),
            ),
            style: const TextStyle(
              color: CustomColors.white,
            ),
          ),
          VerticalSpacers.medium,
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final bloc = BlocProvider.of<AuthBloc>(context);
                      if (bloc.state is Authenticated) {
                        //TODO: Navigate to voting screen
                        context.pushNamed(Routes.vote.name,
                            params: {'id': codeCtrl.text});
                      } else {
                        bloc.add(SignInWithGoogle(
                          routeName: Routes.vote.name,
                          shouldRedirect: true,
                          params: {'id': codeCtrl.text},
                        ));
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.how_to_vote_rounded,
                        color: CustomColors.white,
                        size: 24,
                      ),
                      HorizontalSpacers.medium,
                      Text("Vote Now"),
                    ],
                  ),
                ),
              ),
              HorizontalSpacers.medium,
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final bloc = BlocProvider.of<AuthBloc>(context);
                      if (bloc.state is Authenticated) {
                        BlocInstances.votingBloc.add(
                          FetchElectionResults(
                            electionCode: codeCtrl.text,
                          ),
                        );
                        context.pushNamed(Routes.result.name,
                            params: {'id': codeCtrl.text});
                      } else {
                        bloc.add(SignInWithGoogle(
                          routeName: Routes.vote.name,
                          shouldRedirect: true,
                          params: {'id': codeCtrl.text},
                        ));
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.bar_chart,
                        // color: CustomColors.white,
                        size: 32,
                      ),
                      HorizontalSpacers.medium,
                      Text(
                        "See result",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
