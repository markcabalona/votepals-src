import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/themes/custom_colors.dart';
import 'package:votepals/core/utils/launch_url.dart';
import 'package:votepals/features/voting/domain/entities/candidate.dart';

class PlaceCandidateWidget extends StatelessWidget {
  const PlaceCandidateWidget({
    Key? key,
    required this.candidate,
  }) : super(key: key);
  final PlaceCandidate candidate;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: AutoSizeText(
                  candidate.name,
                  style: Theme.of(context).textTheme.headline4,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  candidate.city,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              VerticalSpacers.medium,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: candidate.formattedAddress,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        color: CustomColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          customLaunchUrl(
                            'https://www.google.com/search?q=${candidate.formattedAddress}',
                          );
                        },
                    ),
                  ],
                ),
              ),
              VerticalSpacers.medium,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
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
