// ignore_for_file: public_member_api_docs, sort_constructors_first
class VPException implements Exception {
  final String? message;
  const VPException({
    this.message,
  });
}

class VotingException extends VPException {
  VotingException({super.message});
}
