// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  final bool shouldRedirect;
  final String? routeName;
  final Map<String, String> params;
  AuthInitial({
    this.shouldRedirect = false,
    this.routeName,
    this.params = const <String, String>{},
  }) {
    if (shouldRedirect) {
      assert(routeName != null);
    }
  }
}

class Authenticated extends AuthState {
  final User user;
  final bool shouldRedirect;
  final String? routeName;
  final Map<String, String> params;
  Authenticated({
    required this.user,
    this.shouldRedirect = false,
    this.routeName,
    this.params = const <String, String>{},
  }) {
    if (shouldRedirect) {
      assert(routeName != null);
    }
  }
  @override
  List<Object> get props => super.props..add(user);
}

class UnAuthenticated extends AuthState {
  const UnAuthenticated();
}
