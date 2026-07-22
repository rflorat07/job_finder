import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/inbox_remote_datasource.dart';
import '../../data/repositories/inbox_repository_impl.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../controllers/chat_view_model.dart';

/// Chat (message details) screen for a single conversation.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversation});

  /// The conversation opened from the Inbox list.
  final ConversationEntity conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final datasource = SupabaseInboxRemoteDataSource(client);
    final repository = InboxRepositoryImpl(datasource);
    _viewModel = ChatViewModel(
      repository,
      conversationId: widget.conversation.id,
    );
    _viewModel.addListener(_scrollToBottomOnChange);
    _viewModel.loadMessages();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_scrollToBottomOnChange);
    _viewModel.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Keeps the newest message visible after load/send.
  void _scrollToBottomOnChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _onSend() async {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    await _viewModel.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: widget.conversation.contactName,
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          iconColor: context.dsColors.onSurface,
          onPressed: () => context.pop(),
        ),
        actions: [
          DSCircularIcon.icon(
            IconsaxPlusLinear.more,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            backgroundColor: context.dsColors.secondaryContainer,
            iconColor: context.dsColors.onSurface,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return switch (_viewModel.state) {
                    ChatState.loading => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    ChatState.error => _ChatError(
                      message: _viewModel.errorMessage,
                      onRetry: _viewModel.loadMessages,
                    ),
                    ChatState.loaded => _MessagesList(
                      scrollController: _scrollController,
                      messages: _viewModel.messages,
                    ),
                  };
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.spacing24,
                SpacingTokens.spacing8,
                SpacingTokens.spacing24,
                SpacingTokens.spacing12,
              ),
              child: DSMessageInputBar(
                controller: _inputController,
                hintText: context.tr('inbox.type_message'),
                onAttach: () {},
                onSend: _onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The chronological list of chat bubbles, preceded by a date badge.
class _MessagesList extends StatelessWidget {
  const _MessagesList({
    required this.scrollController,
    required this.messages,
  });

  final ScrollController scrollController;
  final List<MessageEntity> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const _ChatEmpty();
    }

    return ListView.separated(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.spacing24,
        SpacingTokens.spacing16,
        SpacingTokens.spacing24,
        SpacingTokens.spacing16,
      ),
      itemCount: messages.length + 1,
      separatorBuilder: (_, _) =>
          const SizedBox(height: SpacingTokens.spacing16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _DateBadge();
        }
        final message = messages[index - 1];
        return DSChatBubble(
          message: message.body,
          time: DateFormat('h.mm a').format(message.createdAt),
          isMine: message.isMine,
        );
      },
    );
  }
}

/// Centered grey pill showing the conversation day (e.g. "Today").
class _DateBadge extends StatelessWidget {
  const _DateBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing12,
          vertical: SpacingTokens.spacing4,
        ),
        decoration: BoxDecoration(
          color: context.dsColors.secondary,
          borderRadius: RadiusTokens.lgRadius,
        ),
        child: Text(
          context.tr('inbox.today'),
          style: context.dsTextTheme.bodySmall?.copyWith(
            color: context.dsColors.onSurfaceVariant,
            fontWeight: TypographyTokens.fontWeightMedium,
          ),
        ),
      ),
    );
  }
}

/// Error state with a retry action.
class _ChatError extends StatelessWidget {
  const _ChatError({required this.message, required this.onRetry});

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? context.tr('inbox.generic_error'),
            textAlign: TextAlign.center,
            style: context.dsTextTheme.bodyLarge,
          ),
          const SizedBox(height: SpacingTokens.spacing16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(context.tr('home.retry')),
          ),
        ],
      ),
    );
  }
}

/// Placeholder shown when a conversation has no messages yet.
class _ChatEmpty extends StatelessWidget {
  const _ChatEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr('inbox.no_messages'),
        style: context.dsTextTheme.bodyMedium?.copyWith(
          color: context.dsColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
