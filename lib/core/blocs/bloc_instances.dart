import 'package:votepals/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:votepals/features/voting/data/datasources/voting_datasource_impl.dart';
import 'package:votepals/features/voting/data/repositories/voting_repository.dart';
import 'package:votepals/features/voting/presentation/bloc/geolocator_bloc.dart';
import 'package:votepals/features/voting/presentation/bloc/voting_bloc.dart';

abstract class BlocInstances {
  static final AuthBloc authBloc = AuthBloc();
  static final VotingBloc votingBloc = VotingBloc(
    repository: VotingRepositoryImpl(
      dataSource: VotingDataSourceImpl(),
    ),
  );
  static final GeolocatorBloc geolocatorBloc = GeolocatorBloc();
}
