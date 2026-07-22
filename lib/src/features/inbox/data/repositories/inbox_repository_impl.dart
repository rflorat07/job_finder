import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/inbox_repository.dart';
import '../datasources/inbox_remote_datasource.dart';

/// Concrete implementation of [InboxRepository].
/// Orchestrates the datasource and maps low-level errors into [Failure]s.
class InboxRepositoryImpl implements InboxRepository {
  final InboxRemoteDataSource _remoteDataSource;

  InboxRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ConversationEntity>>> fetchConversations() async {
    try {
      final models = await _remoteDataSource.fetchConversations();
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to fetch conversations', error: e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> fetchMessages(
    String conversationId,
  ) async {
    try {
      final models = await _remoteDataSource.fetchMessages(conversationId);
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to fetch messages', error: e));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String body,
  }) async {
    try {
      final model = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        body: body,
      );
      return Right(model);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to send message', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> markConversationRead(
    String conversationId,
  ) async {
    try {
      await _remoteDataSource.markConversationRead(conversationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update conversation', error: e));
    }
  }
}
