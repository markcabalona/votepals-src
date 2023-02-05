// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateEvent extends AuthEvent {
  final User user;
  final bool shouldRedirect;
  final String? routeName;
  final Map<String, String> params;
  AuthenticateEvent({
    required this.user,
    required this.shouldRedirect,
    this.routeName,
    this.params = const <String, String>{},
  }) {
    if (shouldRedirect) {
      assert(routeName != null);
    }
  }
}

class UnAuthenticateEvent extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {
  final bool shouldRedirect;
  final String? routeName;
  final Map<String, String> params;
  SignInWithGoogle({
    this.shouldRedirect = false,
    this.routeName,
    this.params = const <String, String>{},
  }) {
    if (shouldRedirect) {
      assert(routeName != null);
    }
  }
}

class Logout extends AuthEvent {}
