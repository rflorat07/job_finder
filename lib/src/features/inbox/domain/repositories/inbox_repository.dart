import '../../../../utils/typedefs.dart';
import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

/// Contract for inbox data operations. Implemented in the data layer.
abstract class InboxRepository {
  /// Fetches the current user's conversations, ordered by most recent activity.
  FutureEither<List<ConversationEntity>> fetchConversations();

  /// Fetches the messages of a conversation, ordered chronologically.
  FutureEither<List<MessageEntity>> fetchMessages(String conversationId);

  /// Sends a message in a conversation and returns the stored message.
  FutureEither<MessageEntity> sendMessage({
    required String conversationId,
    required String body,
  });

  /// Marks a conversation as read (resets its unread counter).
  FutureEitherVoid markConversationRead(String conversationId);
}
