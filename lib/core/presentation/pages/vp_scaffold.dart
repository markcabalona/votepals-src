// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';
import 'package:votepals/core/presentation/pages/main_page.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/core/themes/custom_colors.dart';

class VPScaffold extends StatelessWidget {
  const VPScaffold({
    Key? key,
    required this.body,
  }) : super(key: key);
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {
            if (AppRouter.router.location != Routes.home.path) {
              AppRouter.router.goNamed(Routes.home.name);
            }
          },
          child: Text.rich(
            const TextSpan(
              children: [
                TextSpan(
                  text: 'VOTE ',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: 'PALS',
                ),
              ],
            ),
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: CustomColors.dark,
                  fontWeight: FontWeight.w200,
                ),
          ),
        ),
        actions: const [
          DynamicActionButton(),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: body,
    );
  }
}
