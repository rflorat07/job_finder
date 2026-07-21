import '../../../../utils/typedefs.dart';
import '../entities/interview_entity.dart';

/// Contract for retrieving interviews. Implemented in the data layer.
abstract class InterviewRepository {
  /// Fetches the interviews for the current user, ordered by schedule date.
  FutureEither<List<InterviewEntity>> fetchInterviews();
}
