import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../../domain/entities/country_entity.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  final CountryEntity? initialSelection;

  const CountrySelectionBottomSheet({
    super.key,
    this.initialSelection,
  });

  /// Helper static method to show this bottom sheet
  static Future<CountryEntity?> show(
    BuildContext context, {
    CountryEntity? initialSelection,
  }) {
    return showModalBottomSheet<CountryEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea:
          true, // Esto hace que respete el 'notch' y la barra de estado superior
      backgroundColor: Colors.transparent,
      builder: (context) => CountrySelectionBottomSheet(
        initialSelection: initialSelection,
      ),
    );
  }

  @override
  State<CountrySelectionBottomSheet> createState() =>
      _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState
    extends State<CountrySelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<CountryEntity> _filteredCountries;
  CountryEntity? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialSelection;
    _filteredCountries = CountryEntity.mocks; // Start with all countries

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = CountryEntity.mocks
          .where((country) => country.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _selectCountry(CountryEntity country) {
    setState(() {
      _selectedCountry = country;
    });

    // Pequeño retardo para que el usuario alcance a ver que se seleccionó
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.of(context).pop(_selectedCountry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use a Scaffold inside the bottom sheet to let it stretch naturally
    // and easily handle keyboard inputs for the search bar.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity, // Now it correctly fills the Scaffold
        decoration: const BoxDecoration(
          color: Color(PrimitiveColors.greyscale25),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RadiusTokens.xl2),
            topRight: Radius.circular(RadiusTokens.xl2),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: SpacingTokens.spacing24),
            // HEADER (Close Button + Title)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    child: Container(
                      width: SizesTokens.size44,
                      height: SizesTokens.size44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.dsColors.surface,
                      ),
                      child: Icon(
                        Icons.close,
                        size: SizesTokens.size20,
                        color: context.dsColors.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.tr('setup_account.select_country'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: TypographyTokens.fontWeightBold,
                      ),
                    ),
                  ),

                  const SizedBox(width: SizesTokens.size44),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing24),

            // SEARCH BAR (Simulada usando tu Design System)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: DSTextFormField(
                controller: _searchController,
                hint: context.tr('setup_account.search_country'),
                prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1),
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing24),

            // LIST OF COUNTRIES
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: SpacingTokens.spacing24,
                  right: SpacingTokens.spacing24,
                  bottom: SpacingTokens.spacing24,
                ),
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: SpacingTokens.spacing16),
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = _selectedCountry?.code == country.code;

                  return DSCountry(
                    onTap: () => _selectCountry(country),
                    countryName: country.name,
                    isSelected: isSelected,
                    countryFlagAsset:
                        'assets/flags/${country.code.toLowerCase()}.svg',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
