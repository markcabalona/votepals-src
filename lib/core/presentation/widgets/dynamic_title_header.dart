import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/themes/custom_colors.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';

class DynamictTitleHeader extends StatelessWidget {
  const DynamictTitleHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .headline3
        ?.copyWith(color: CustomColors.dark);
    return Wrap(
      children: [
        Text(
          'Hi there, ',
          style: style,
          textAlign: TextAlign.left,
        ),
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            if (current is Authenticated && current.shouldRedirect) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                AppRouter.router.pushNamed(
                  current.routeName!,
                  params: current.params,
                );
              });
            }
            return true;
          },
          builder: (context, state) {
            final bool isAuthenticated = state is Authenticated;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(state),
                '${isAuthenticated ? state.user.displayName : 'voter'}!',
                style: style,
                textAlign: TextAlign.left,
              ),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
