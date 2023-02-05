import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/core/themes/custom_colors.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';

class ElectionCodeDialog extends StatelessWidget {
  const ElectionCodeDialog({
    Key? key,
    required this.electionCode,
  }) : super(key: key);
  final String electionCode;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          // maxHeight: 300,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CustomPaddings.large,
            vertical: CustomPaddings.medium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To allow your friends to vote for this election, copy the election code below and send it to them. Voting period will be open from ${dateToStringTime(DateTime.now())} to ${dateToStringTime(DateTime.now().add(const Duration(minutes: 30)))} of today\'s date only.  Make sure that you save this code so you can use it to see the result later.',
              ),
              VerticalSpacers.large,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: null,
                    // style: TextButton.styleFrom(
                    //   backgroundColor: Colors.grey
                    // ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SelectableText(
                            electionCode,
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: electionCode,
                            ));
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ),
                  VerticalSpacers.medium,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Pop the dialog
                            Navigator.pop(context);
                            // Pop the create page (go back to home page)
                            AppRouter.router.goNamed(Routes.home.name);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.home,
                                size: 24,
                              ),
                              HorizontalSpacers.medium,
                              Text("Home"),
                            ],
                          ),
                        ),
                      ),
                      HorizontalSpacers.medium,
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            final bloc = BlocInstances.authBloc;
                            Navigator.pop(context);
                            if (bloc.state is Authenticated) {
                              AppRouter.router.goNamed(
                                Routes.vote.name,
                                params: {'id': electionCode},
                              );
                            } else {
                              bloc.add(SignInWithGoogle(
                                routeName: Routes.vote.name,
                                shouldRedirect: true,
                                params: {'id': electionCode},
                              ));
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
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String dateToStringTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }
}
