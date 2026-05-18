import 'setup_payload_entity.dart';

abstract class SetupRepository {
  /// Sends the complete profile setup data to the backend.
  Future<void> completeSetup(SetupPayloadEntity payload);
}
