import 'package:flutter/foundation.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/inbox_repository.dart';

/// Possible states for the Inbox screen.
enum InboxState { loading, loaded, empty, error }

/// Manages the Inbox screen: loads conversations and filters them by a
/// search query. Uses [ChangeNotifier] following the project's MVVM convention.
class InboxViewModel extends ChangeNotifier {
  final InboxRepository _repository;

  InboxViewModel(this._repository);

  InboxState _state = InboxState.loading;
  String? _errorMessage;
  String _query = '';
  List<ConversationEntity> _conversations = [];

  /// Current screen state.
  InboxState get state => _state;

  /// Error message (only relevant when [state] == [InboxState.error]).
  String? get errorMessage => _errorMessage;

  /// Conversations filtered by the current search [_query].
  List<ConversationEntity> get conversations {
    if (_query.isEmpty) return List.unmodifiable(_conversations);

    final lowerQuery = _query.toLowerCase();
    return _conversations
        .where(
          (c) =>
              c.contactName.toLowerCase().contains(lowerQuery) ||
              c.lastMessage.toLowerCase().contains(lowerQuery),
        )
        .toList(growable: false);
  }

  /// Loads the current user's conversations.
  Future<void> loadConversations() async {
    _state = InboxState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchConversations();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = InboxState.error;
      },
      (items) {
        _conversations = items;
        _state = items.isEmpty ? InboxState.empty : InboxState.loaded;
      },
    );

    notifyListeners();
  }

  /// Updates the search query and refreshes the filtered list.
  void search(String query) {
    _query = query;
    notifyListeners();
  }
}
