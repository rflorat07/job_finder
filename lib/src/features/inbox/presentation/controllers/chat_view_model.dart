import 'package:flutter/foundation.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/inbox_repository.dart';

/// Possible states for the Chat (message details) screen.
enum ChatState { loading, loaded, error }

/// Manages a single conversation: loads its messages and sends new ones.
/// Uses [ChangeNotifier] following the project's MVVM convention.
class ChatViewModel extends ChangeNotifier {
  final InboxRepository _repository;
  final String conversationId;

  ChatViewModel(this._repository, {required this.conversationId});

  ChatState _state = ChatState.loading;
  String? _errorMessage;
  bool _isSending = false;
  List<MessageEntity> _messages = [];

  /// Current screen state.
  ChatState get state => _state;

  /// Error message (only relevant when [state] == [ChatState.error]).
  String? get errorMessage => _errorMessage;

  /// Whether a message is currently being sent.
  bool get isSending => _isSending;

  /// Chronologically ordered messages of the conversation.
  List<MessageEntity> get messages => List.unmodifiable(_messages);

  /// Loads the conversation messages and marks it as read.
  Future<void> loadMessages() async {
    _state = ChatState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchMessages(conversationId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = ChatState.error;
      },
      (items) {
        _messages = items;
        _state = ChatState.loaded;
      },
    );

    notifyListeners();

    // Mark as read in the background; failures here are non-blocking.
    await _repository.markConversationRead(conversationId);
  }

  /// Sends a message. Optimistically appends it on success.
  Future<void> sendMessage(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty || _isSending) return;

    _isSending = true;
    notifyListeners();

    final result = await _repository.sendMessage(
      conversationId: conversationId,
      body: trimmed,
    );
    result.fold(
      (failure) => _errorMessage = failure.message,
      (message) => _messages = [..._messages, message],
    );

    _isSending = false;
    notifyListeners();
  }
}
