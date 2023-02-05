// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'route.dart';

abstract class Routes {
  static const home = _Route(
    path: '/',
    name: 'home',
  );

  static const result = _Route(
    path: '/result/:id',
    name: 'result',
  );

  static const vote = _Route(
    path: '/vote/:id',
    name: 'vote',
  );

  static const createElection = _Route(
    path: '/create',
    name: 'create-election',
  );
}

