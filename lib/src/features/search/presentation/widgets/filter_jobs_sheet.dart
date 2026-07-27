import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/search_filters.dart';

/// Bottom sheet that lets the user refine the job search.
///
/// Mirrors the "Filter Jobs" design (Frame 41575): a title, four dropdown
/// fields (Location, Job Type, Work Mode, Sort By) and a Reset/Apply row.
///
/// Returns the newly selected [SearchFilters] via [Navigator.pop] when the
/// user taps **Apply**, or `null` when dismissed.
class FilterJobsSheet extends StatefulWidget {
  /// Filters currently applied, used as the initial draft.
  final SearchFilters current;

  /// Distinct locations available for the Location dropdown.
  final List<String> locations;

  const FilterJobsSheet({
    super.key,
    required this.current,
    required this.locations,
  });

  /// Shows the sheet and resolves with the chosen [SearchFilters] or `null`.
  static Future<SearchFilters?> show(
    BuildContext context, {
    required SearchFilters current,
    required List<String> locations,
  }) {
    return showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterJobsSheet(current: current, locations: locations),
    );
  }

  @override
  State<FilterJobsSheet> createState() => _FilterJobsSheetState();
}

class _FilterJobsSheetState extends State<FilterJobsSheet> {
  // Local draft — nothing is applied until the user taps "Apply".
  late SearchFilters _draft = widget.current;

  Future<void> _pickLocation() async {
    // The first option ("All locations") maps to a null location.
    final options = <_Option<String?>>[
      _Option(null, context.tr('search.location_any')),
      ...widget.locations.map((l) => _Option<String?>(l, l)),
    ];

    final selected = await _showOptions<String?>(
      title: context.tr('search.filter_location'),
      options: options,
      selected: _draft.location,
    );
    if (selected == null) return;

    setState(() {
      _draft = selected.value == null
          ? _draft.copyWith(clearLocation: true)
          : _draft.copyWith(location: selected.value);
    });
  }

  Future<void> _pickJobType() async {
    final selected = await _showOptions<JobTypeFilter>(
      title: context.tr('search.filter_job_type'),
      options: JobTypeFilter.values
          .map((v) => _Option(v, context.tr(v.labelKey)))
          .toList(),
      selected: _draft.jobType,
    );
    if (selected == null) return;
    setState(() => _draft = _draft.copyWith(jobType: selected.value));
  }

  Future<void> _pickWorkMode() async {
    final selected = await _showOptions<WorkModeFilter>(
      title: context.tr('search.filter_work_mode'),
      options: WorkModeFilter.values
          .map((v) => _Option(v, context.tr(v.labelKey)))
          .toList(),
      selected: _draft.workMode,
    );
    if (selected == null) return;
    setState(() => _draft = _draft.copyWith(workMode: selected.value));
  }

  Future<void> _pickSort() async {
    final selected = await _showOptions<JobSort>(
      title: context.tr('search.filter_sort'),
      options: JobSort.values
          .map((v) => _Option(v, context.tr(v.labelKey)))
          .toList(),
      selected: _draft.sort,
    );
    if (selected == null) return;
    setState(() => _draft = _draft.copyWith(sort: selected.value));
  }

  /// Opens a nested sheet listing [options] and returns the chosen one.
  Future<_Option<T>?> _showOptions<T>({
    required String title,
    required List<_Option<T>> options,
    required T selected,
  }) {
    return showModalBottomSheet<_Option<T>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.dsColors.secondaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl2),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SpacingTokens.spacing24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.spacing24,
                  ),
                  child: Text(
                    title,
                    style: context.dsTextTheme.bodyLarge?.copyWith(
                      color: context.dsColors.onSurface,
                      fontWeight: TypographyTokens.fontWeightBold,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingTokens.spacing8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option.value == selected;
                      return ListTile(
                        title: Text(
                          option.label,
                          style: context.dsTextTheme.bodyMedium?.copyWith(
                            color: context.dsColors.onSurface,
                            fontWeight: isSelected
                                ? TypographyTokens.fontWeightSemiBold
                                : TypographyTokens.fontWeightRegular,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                IconsaxPlusLinear.tick_circle,
                                color: context.dsColors.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(option),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onReset() {
    setState(() => _draft = _draft.cleared());
  }

  void _onApply() {
    Navigator.of(context).pop(_draft);
  }

  @override
  Widget build(BuildContext context) {
    final locationText = _draft.location ?? context.tr('search.location_any');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Design: padding 48px top, 24px sides, 40px bottom.
          padding: const EdgeInsets.fromLTRB(
            SpacingTokens.spacing24,
            SpacingTokens.spacing48,
            SpacingTokens.spacing24,
            SpacingTokens.spacing40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  context.tr('search.filter_title'),
                  style: context.dsTextTheme.bodyLarge?.copyWith(
                    color: context.dsColors.onSurface,
                    fontWeight: TypographyTokens.fontWeightBold,
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.spacing32),

              // ===== Dropdown fields =====
              _FilterDropdown(
                label: context.tr('search.filter_location'),
                valueText: locationText,
                onTap: _pickLocation,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              _FilterDropdown(
                label: context.tr('search.filter_job_type'),
                valueText: context.tr(_draft.jobType.labelKey),
                onTap: _pickJobType,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              _FilterDropdown(
                label: context.tr('search.filter_work_mode'),
                valueText: context.tr(_draft.workMode.labelKey),
                onTap: _pickWorkMode,
              ),
              const SizedBox(height: SpacingTokens.spacing16),
              _FilterDropdown(
                label: context.tr('search.filter_sort'),
                valueText: context.tr(_draft.sort.labelKey),
                onTap: _pickSort,
              ),
              const SizedBox(height: SpacingTokens.spacing32),

              // ===== Reset / Apply =====
              Row(
                children: [
                  Expanded(
                    child: DSButton(
                      label: context.tr('search.filter_reset'),
                      size: DSButtonSize.medium,
                      type: DSButtonType.secondary,
                      state: DSButtonState.primary,
                      onPressed: _onReset,
                      customStyle: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide.none),
                        foregroundColor: WidgetStateProperty.all(
                          context.dsColors.primary,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          context.dsColors.primary.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.spacing16),
                  Expanded(
                    child: DSButton(
                      label: context.tr('search.filter_apply'),
                      size: DSButtonSize.medium,
                      onPressed: _onApply,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single labelled dropdown field (label on top, bordered value box below).
class _FilterDropdown extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback onTap;

  const _FilterDropdown({
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.dsTextTheme.bodySmall?.copyWith(
            color: context.dsColors.onSurface,
            fontWeight: TypographyTokens.fontWeightMedium,
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing6),
        InkWell(
          onTap: onTap,
          borderRadius: RadiusTokens.smRadius,
          child: Container(
            height: SizesTokens.size48,
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacing12,
            ),
            decoration: BoxDecoration(
              color: context.dsColors.secondaryContainer,
              borderRadius: RadiusTokens.smRadius,
              border: Border.all(color: context.dsColors.outlineVariant),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    valueText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.dsTextTheme.bodyMedium?.copyWith(
                      color: context.dsColors.onSurface,
                      fontWeight: TypographyTokens.fontWeightRegular,
                    ),
                  ),
                ),
                Icon(
                  IconsaxPlusLinear.arrow_down,
                  size: SizesTokens.size20,
                  color: context.dsColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Lightweight pairing of a value and its human-readable label.
class _Option<T> {
  final T value;
  final String label;

  const _Option(this.value, this.label);
}
