// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/core/themes/custom_colors.dart';

class VoteRecordedDialog extends StatelessWidget {
  const VoteRecordedDialog({
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
              const Text(
                'Your vote has been recorded. You can monitor the results in the results dashboard.',
              ),
              VerticalSpacers.large,
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
                        Navigator.pop(context);
                        AppRouter.router.goNamed(Routes.result.name, params: {
                          'id': electionCode,
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.bar_chart,
                            color: CustomColors.white,
                            size: 24,
                          ),
                          HorizontalSpacers.medium,
                          Text("See Results"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
