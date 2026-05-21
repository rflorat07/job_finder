import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/setup_payload_model.dart';

abstract class SetupRemoteDataSource {
  Future<void> completeSetup(SetupPayloadModel payload);

  /// Uploads a profile image to Supabase Storage and returns the public URL.
  Future<String> uploadProfileImage(File imageFile);
}

class SupabaseSetupRemoteDataSource implements SetupRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseSetupRemoteDataSource(this._supabaseClient);

  @override
  Future<void> completeSetup(SetupPayloadModel payload) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final data = payload.toJson();

    // Como ahora sabemos que el Trigger creó la fila,
    // lo correcto semánticamente es usar update() filtrando por el id.
    await _supabaseClient.from('profiles').update(data).eq('id', user.id);
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final extension = imageFile.path.split('.').last;
    final filePath = '${user.id}/avatar.$extension';

    await _supabaseClient.storage
        .from('avatars')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _supabaseClient.storage
        .from('avatars')
        .getPublicUrl(filePath);

    return publicUrl;
  }
}
