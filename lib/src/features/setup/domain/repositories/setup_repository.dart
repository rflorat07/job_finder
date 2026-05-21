import 'dart:io';

import '../entities/entities.dart';

abstract class SetupRepository {
  /// Sends the complete profile setup data to the backend.
  Future<void> completeSetup(SetupPayloadEntity payload);

  /// Uploads a profile image and returns the public URL.
  Future<String> uploadProfileImage(File imageFile);
}
