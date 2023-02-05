import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:votepals/core/presentation/pages/main_page.dart';
import 'package:votepals/core/presentation/pages/vp_scaffold.dart';
import 'package:votepals/core/router/routes.dart';
import 'package:votepals/features/voting/presentation/pages/new_voting_page.dart';
import 'package:votepals/features/voting/presentation/pages/result_page.dart';
import 'package:votepals/features/voting/presentation/pages/sumbit_voting_page.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.home.path,
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) => MaterialPage(
          child: VPScaffold(body: child),
        ),
        routes: [
          GoRoute(
            path: Routes.home.path,
            name: Routes.home.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: MainPage(),
              );
            },
          ),
          GoRoute(
            path: Routes.createElection.path,
            name: Routes.createElection.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: Scaffold(
                  body: NewVotingScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.result.path,
            name: Routes.result.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: Scaffold(
                  body: VPResultPage(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.vote.path,
            name: Routes.vote.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: Scaffold(
                  body: SubmitVotePage()
                ),
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text('404: ${state.location} not found.'),
          ),
        ),
      );
    },
  );
}
