// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:votepals/features/voting/domain/entities/candidate.dart';

class SubmitVoteParams {
  final String electionCode;
  final List<PlaceCandidate> candidates;
  const SubmitVoteParams({
    required this.electionCode,
    required this.candidates,
  });
}
