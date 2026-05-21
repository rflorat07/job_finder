import 'dart:io';

import '../../domain/entities/setup_payload_entity.dart';
import '../../domain/repositories/setup_repository.dart';
import '../datasources/setup_remote_datasource.dart';
import '../models/setup_payload_model.dart';

class SetupRepositoryImpl implements SetupRepository {
  final SetupRemoteDataSource remoteDataSource;

  SetupRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> completeSetup(SetupPayloadEntity payload) async {
    final model = SetupPayloadModel.fromEntity(payload);
    await remoteDataSource.completeSetup(model);
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    return remoteDataSource.uploadProfileImage(imageFile);
  }
}
