import '../../../../utils/typedefs.dart';
import '../entities/hot_vacancy_entity.dart';

/// Contract that defines what data operations the Home feature needs.
/// Lives in the domain layer — knows nothing about Supabase or JSON.
abstract class HomeRepository {
  /// Returns a list of companies with active job counts.
  FutureEither<List<HotVacancyEntity>> getHotVacancies();
}
