import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A circular avatar widget with an optional edit button overlay.
///
/// Displays either a user-selected image or a placeholder icon.
/// Tapping the edit badge triggers [onPickImage] to let the user
/// select a new profile photo.
class DSAvatarPicker extends StatelessWidget {
  const DSAvatarPicker({
    super.key,
    this.imageFile,
    this.imageUrl,
    this.size = 88,
    this.onPickImage,
    this.placeholderColor,
    this.backgroundColor,
    this.badgeColor,
  });

  /// Local file selected by the user.
  final File? imageFile;

  /// Network URL for an existing avatar.
  final String? imageUrl;

  /// Diameter of the avatar circle.
  final double size;

  /// Callback when the edit badge is tapped.
  final VoidCallback? onPickImage;

  /// Background color of the placeholder circle.
  final Color? placeholderColor;

  /// Background color when showing an image (border tint).
  final Color? backgroundColor;

  /// Color of the edit badge circle.
  final Color? badgeColor;

  bool get _hasImage => imageFile != null || imageUrl != null;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        placeholderColor ??
        context.dsColors.primary.withAlpha(40);
    final editBadgeColor = badgeColor ?? context.dsColors.primary;
    final badgeSize = size * 0.3;
    final iconSize = size * 0.45;

    return GestureDetector(
      onTap: onPickImage,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                image: _hasImage ? _buildDecorationImage() : null,
              ),
              child: _hasImage
                  ? null
                  : Icon(
                      Icons.person,
                      size: iconSize,
                      color: context.dsColors.primary,
                    ),
            ),

            // Edit badge
            if (onPickImage != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: editBadgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: badgeSize * 0.55,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  DecorationImage? _buildDecorationImage() {
    if (imageFile != null) {
      return DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover);
    }
    if (imageUrl != null) {
      return DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover);
    }
    return null;
  }
}

@Preview(name: 'DSAvatarPicker Preview', brightness: Brightness.light)
Widget dsAvatarPickerPreview() {
  return DsPreviewScaffold(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Placeholder state
          DSAvatarPicker(onPickImage: () {}),

          // Without edit badge
          const DSAvatarPicker(size: 64),
        ],
      ),
    ],
  );
}
