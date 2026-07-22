import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';

/// Defines the contract for external inbox data operations.
abstract class InboxRemoteDataSource {
  Future<List<ConversationModel>> fetchConversations();
  Future<List<MessageModel>> fetchMessages(String conversationId);
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String body,
  });
  Future<void> markConversationRead(String conversationId);
}

/// Supabase concrete implementation. ONLY this class talks to Supabase.
class SupabaseInboxRemoteDataSource implements InboxRemoteDataSource {
  final SupabaseClient _client;

  SupabaseInboxRemoteDataSource(this._client);

  String _currentUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found.');
    }
    return user.id;
  }

  @override
  Future<List<ConversationModel>> fetchConversations() async {
    final userId = _currentUserId();

    final response = await _client
        .from('conversations')
        .select()
        .eq('user_id', userId)
        .order('last_message_at', ascending: false);

    return response.map((json) => ConversationModel.fromJson(json)).toList();
  }

  @override
  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    final userId = _currentUserId();

    final response = await _client
        .from('messages')
        .select()
        .eq('user_id', userId)
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return response.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String body,
  }) async {
    final userId = _currentUserId();

    final response = await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'user_id': userId,
          'is_mine': true,
          'body': body,
        })
        .select()
        .single();

    return MessageModel.fromJson(response);
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    final userId = _currentUserId();

    await _client
        .from('conversations')
        .update({'unread_count': 0})
        .eq('id', conversationId)
        .eq('user_id', userId);
  }
}
