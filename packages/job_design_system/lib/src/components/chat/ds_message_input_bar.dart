import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A chat composer: a rounded text field with an optional trailing icon and a
/// circular send button. Designed to sit at the bottom of a chat screen.
class DSMessageInputBar extends StatelessWidget {
  /// Controller for the message text.
  final TextEditingController controller;

  /// Placeholder text.
  final String hintText;

  /// Trailing icon (e.g. camera). Hidden when null.
  final IconData icon;

  /// Called when the send button is tapped.
  final VoidCallback? onSend;

  /// Called when the trailing (camera) icon is tapped. Hidden when null.
  final VoidCallback? onAttach;

  const DSMessageInputBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSend,
    this.onAttach,
    this.icon = Icons.photo_camera_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: SpacingTokens.spacing16,
              right: SpacingTokens.spacing16,
            ),
            decoration: BoxDecoration(
              color: context.dsColors.secondaryContainer,
              borderRadius: RadiusTokens.fullRadius,
            ),
            child: ClipRRect(
              borderRadius: RadiusTokens.fullRadius,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      cursorColor: context.dsColors.primary,
                      style: context.dsTextTheme.bodyMedium?.copyWith(
                        color: context.dsColors.onSurface,
                        fontWeight: TypographyTokens.fontWeightRegular,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: SpacingTokens.spacing16,
                        ),
                        hintText: hintText,
                        hintStyle: context.dsTextTheme.bodyMedium?.copyWith(
                          color: context.dsColors.secondary,
                          fontWeight: TypographyTokens.fontWeightRegular,
                        ),
                      ),
                    ),
                  ),
                  if (onAttach != null)
                    GestureDetector(
                      onTap: onAttach,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        icon,
                        color: context.dsColors.secondary,
                        size: SizesTokens.size24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: SpacingTokens.spacing12),
        _SendButton(onSend: onSend),
      ],
    );
  }
}

/// Circular primary send button.
class _SendButton extends StatelessWidget {
  const _SendButton({this.onSend});

  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Send',
      child: GestureDetector(
        onTap: onSend,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: SizesTokens.size52,
          height: SizesTokens.size52,
          decoration: BoxDecoration(
            color: context.dsColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.send_rounded,
            color: context.dsColors.onPrimary,
            size: SizesTokens.size20,
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSMessageInputBar Preview', brightness: Brightness.light)
Widget dsMessageInputBarPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      DSMessageInputBar(
        controller: TextEditingController(),
        hintText: 'Type a message',
        onAttach: () {},
        onSend: () {},
      ),
    ],
  );
}
