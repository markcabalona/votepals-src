import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _googleProvider = GoogleAuthProvider()
    ..addScope(
      'https://www.googleapis.com/auth/contacts.readonly',
    );

  AuthBloc() : super(AuthInitial()) {
    final auth = FirebaseAuth.instance;

    on<AuthenticateEvent>((event, emit) {
      emit(Authenticated(
          user: event.user,
          shouldRedirect: event.shouldRedirect,
          routeName: event.routeName,
          params: event.params));
    });

    on<UnAuthenticateEvent>((event, emit) => emit(const UnAuthenticated()));

    on<SignInWithGoogle>((event, emit) async {
      try {
        emit(AuthInitial(
          routeName: event.routeName,
          shouldRedirect: event.shouldRedirect,
          params: event.params,
        ));
        await auth
            .signInWithPopup(
              _googleProvider,
            )
            .onError((error, stackTrace) => throw Exception(error));
      } catch (e) {
        log(e.toString());
      }
    });

    on<Logout>((event, emit) {
      auth.signOut();
    });
  }
}
