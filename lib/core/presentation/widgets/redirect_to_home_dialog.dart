// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/router/routes.dart';

class RedirectToHomeDialog extends StatelessWidget {
  const RedirectToHomeDialog({
    Key? key,
    required this.text,
    this.textAlign,
  }) : super(key: key);
  final String text;
  final TextAlign? textAlign;

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
                text,
                style: Theme.of(context).textTheme.headline6,
                textAlign: textAlign,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
