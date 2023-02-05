enum FailureCode {
  requestFailure,
  serverFailure,
  dataModelFailure,
}

abstract class Failure {
  final String message;
  final FailureCode? code;
  const Failure({
    required this.message,
    this.code,
  });
}

class VotingFailure extends Failure {
  VotingFailure({
    required super.message,
    super.code,
  });
}
