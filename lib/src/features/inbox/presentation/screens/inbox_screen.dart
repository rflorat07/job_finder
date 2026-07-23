import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/inbox_remote_datasource.dart';
import '../../data/repositories/inbox_repository_impl.dart';
import '../../domain/entities/conversation_entity.dart';
import '../controllers/inbox_view_model.dart';

/// Inbox screen: a searchable list of the user's conversations.
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final InboxViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final datasource = SupabaseInboxRemoteDataSource(client);
    final repository = InboxRepositoryImpl(datasource);
    _viewModel = InboxViewModel(repository);
    _viewModel.loadConversations();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() => _viewModel.loadConversations();

  Future<void> _openConversation(ConversationEntity conversation) async {
    await context.push(AppRoutes.messageDetail, extra: conversation);
    // Refresh unread counters after returning from the chat.
    await _viewModel.loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('inbox.title'),
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          child: Column(
            spacing: SpacingTokens.spacing16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DSSearchField(
                icon: IconsaxPlusLinear.search_normal_1,
                hintText: context.tr('inbox.search_hint'),
                onChanged: _viewModel.search,
              ),

              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return _InboxBody(
                      viewModel: _viewModel,
                      onRefresh: _onRefresh,
                      onOpen: _openConversation,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Switches the content area based on the current [InboxState].
class _InboxBody extends StatelessWidget {
  const _InboxBody({
    required this.viewModel,
    required this.onRefresh,
    required this.onOpen,
  });

  final InboxViewModel viewModel;
  final Future<void> Function() onRefresh;
  final ValueChanged<ConversationEntity> onOpen;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.state) {
      InboxState.loading => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      InboxState.error => _RefreshableScrollView(
        onRefresh: onRefresh,
        child: _InboxError(message: viewModel.errorMessage),
      ),
      InboxState.empty => _RefreshableScrollView(
        onRefresh: onRefresh,
        child: const _InboxEmpty(),
      ),
      InboxState.loaded => _ConversationsList(
        conversations: viewModel.conversations,
        onRefresh: onRefresh,
        onOpen: onOpen,
      ),
    };
  }
}

/// The scrollable list of conversations.
class _ConversationsList extends StatelessWidget {
  const _ConversationsList({
    required this.conversations,
    required this.onRefresh,
    required this.onOpen,
  });

  final List<ConversationEntity> conversations;
  final Future<void> Function() onRefresh;
  final ValueChanged<ConversationEntity> onOpen;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return _RefreshableScrollView(
        onRefresh: onRefresh,
        child: const _InboxEmpty(),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: SpacingTokens.spacing32),
        itemCount: conversations.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SpacingTokens.spacing16),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return DSConversationTile(
            key: ValueKey(conversation.id),
            name: conversation.contactName,
            avatarUrl: conversation.contactAvatarUrl,
            lastMessage: conversation.lastMessage,
            time: conversation.lastMessageAt != null
                ? DateFormat(
                    'h.mm a',
                    'en_US',
                  ).format(conversation.lastMessageAt!)
                : '',
            unreadCount: conversation.unreadCount,
            onTap: () => onOpen(conversation),
          );
        },
      ),
    );
  }
}

/// Wraps a centered child in a scrollable so pull-to-refresh works even when
/// the content does not fill the viewport (empty / error states).
class _RefreshableScrollView extends StatelessWidget {
  const _RefreshableScrollView({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: child),
            ),
          );
        },
      ),
    );
  }
}

/// Error state shown with a friendly icon + description.
/// Retrying is handled by pull-to-refresh (see [_RefreshableScrollView]).
class _InboxError extends StatelessWidget {
  const _InboxError({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsaxPlusLinear.message_question,
            size: SizesTokens.size48,
            color: context.dsColors.onSurfaceVariant,
          ),
          const SizedBox(height: SpacingTokens.spacing12),
          Text(
            message ?? context.tr('inbox.generic_error'),
            style: context.dsTextTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.spacing8),
          Text(
            context.tr('inbox.error_subtitle'),
            textAlign: TextAlign.center,
            style: context.dsTextTheme.bodyMedium?.copyWith(
              color: context.dsColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder shown when there are no conversations.
class _InboxEmpty extends StatelessWidget {
  const _InboxEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsaxPlusLinear.message,
            size: SizesTokens.size48,
            color: context.dsColors.onSurfaceVariant,
          ),
          const SizedBox(height: SpacingTokens.spacing12),
          Text(
            context.tr('inbox.empty_title'),
            style: context.dsTextTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.spacing8),
          Text(
            context.tr('inbox.empty_subtitle'),
            textAlign: TextAlign.center,
            style: context.dsTextTheme.bodyMedium?.copyWith(
              color: context.dsColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
