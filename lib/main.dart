
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:votepals/core/blocs/bloc_instances.dart';
import 'package:votepals/core/router/app_router.dart';
import 'package:votepals/core/themes/custom_theme.dart';
import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:votepals/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocInstances.authBloc,
        ),
        BlocProvider(
          create: (context) => BlocInstances.votingBloc,
        ),
        BlocProvider(
          create: (context) => BlocInstances.geolocatorBloc,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter.router;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bool shouldRedirect;
          final String? routeName;
          final Map<String, String> params;
          final state = BlocInstances.authBloc.state;
          if (state is AuthInitial) {
            shouldRedirect = state.shouldRedirect;
            routeName = state.routeName;
            params = state.params;
          } else {
            shouldRedirect = false;
            routeName = null;
            params = {};
          }
          BlocInstances.authBloc.add(
            AuthenticateEvent(
              user: snapshot.data!,
              shouldRedirect: shouldRedirect,
              routeName: routeName,
              params: params,
            ),
          );
        } else {
          BlocInstances.authBloc.add(
            UnAuthenticateEvent(),
          );
        }
        return MaterialApp.router(
          title: 'Vote Pals',
          theme: CustomTheme.theme,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
