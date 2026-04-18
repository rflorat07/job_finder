# Job Design Tokens

**Private Flutter Design System tokens package** centralizing design tokens, theming, typography, spacing, radius, and icon semantics.

## 🎯 Overview

This package provides a comprehensive, scalable design system for Flutter applications with:

- **Token-Based Architecture**: Primitive and semantic color tokens
- **Light & Dark Themes**: Complete Material 3 theme configuration
- **Typography System**: Standardized text styles and font definitions
- **Spacing & Radius**: Consistent measurements and border radius
- **UI Split Architecture**: Components live in `job_design_tokens` for cleaner versioning
- **Figma Integration**: Tokens Studio JSON pipeline with code generation

## 📁 Project Structure

```
lib/src/
├── tokens/              # Core design tokens
│   ├── colors/          # Primitive & semantic tokens
│   ├── typography/       # Text styles
│   ├── spacing/         # 8px base-unit scale
│   ├── radius/          # Border radius
│   └── tokens.dart
│
├── theme/               # Theme configuration
│   ├── ds_theme_light.dart
│   ├── ds_theme_dark.dart
│   └── theme.dart
│
├── icons/               # Reserved
└── utils/               # Reserved
```

## 🎨 Quick Start

### Use the theme

```dart
MaterialApp(
  theme: DSThemeLight.build(),
  darkTheme: DSThemeDark.build(),
  themeMode: ThemeMode.auto,
)
```

### Use components

```dart
import 'package:job_design_tokens/job_design_tokens.dart';

DSButton(
  label: 'Submit',
  icon: Icons.check,
  onPressed: () { },
)

DSInput(
  label: 'Email',
  hint: 'user@example.com',
  isRequired: true,
)

DSCard(
  child: Text('Content'),
)
```

## 🧪 Visual QA with Widgetbook

The Design System visual components live in `job_design_tokens`, and their interactive catalog runs in:

- `packages/job_design_tokens/widgetbook`

### Run Widgetbook (web only)

From the repository root:

```bash
cd packages/job_design_tokens/widgetbook
flutter pub get
flutter run -d chrome
```

### Validate Widgetbook build

```bash
cd packages/job_design_tokens/widgetbook
flutter analyze
flutter build web
```

### Access tokens

```dart
Color primary = SemanticColorsLight.primary;
double spacing = SpacingTokens.spacing16;
TextStyle heading = TypographyTokens.headingMedium;
```

## ✅ Current Status (v1.0.0)

- ✅ Clean compilation
- ✅ All tokens defined
- ✅ Light & Dark themes complete
- ✅ Components available via `job_design_tokens`
- ✅ Semantic colors for accessibility
- ✅ Package tests available
- ✅ Figma Tokens Studio pipeline

## 🛠️ Commands

### 1) Create tool structure (if missing)

```bash
mkdir -p tool/tokens_studio
```

Add your Tokens Studio export JSON at:

```text
tool/tokens_studio/tokens.json
```

### 2) Generate token code from Tokens Studio

```bash
dart run tool/generate_tokens.dart
```

This regenerates:

- `lib/src/tokens/colors/primitive_colors.dart`
- `lib/src/tokens/spacing/spacing_scale.dart`
- `lib/src/tokens/radius/radius_scale.dart`
- `lib/src/tokens/typography/font_size_tokens.dart`

### 3) Run tests

```bash
flutter test
```

## 📋 Documentation

See [Full Documentation](./docs/) for comprehensive guides on:
- Token system architecture
- Theme customization
- Component APIs
- Contributing guidelines

## 📄 Version

**1.0.0** - Stable internal release (March 24, 2026)  
Follows SemVer: Major.Minor.Patch
