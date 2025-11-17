import 'package:flutter/material.dart';

import 'country.dart';
import 'country_list_theme_data.dart';
import 'country_list_view.dart';

/// Helper function to determine if a locale uses RTL text direction
bool _isRtlLocale(Locale? locale) {
  if (locale == null) return false;
  
  // RTL language codes
  const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ps', 'ku'];
  return rtlLanguages.contains(locale.languageCode);
}

void showCountryListBottomSheet({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
  VoidCallback? onClosed,
  List<String>? favorite,
  List<String>? exclude,
  List<String>? countryFilter,
  bool showPhoneCode = false,
  CustomFlagBuilder? customFlagBuilder,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus = false,
  bool showWorldWide = false,
  bool showSearch = true,
  bool useSafeArea = false,
  bool useRootNavigator = false,
  bool moveAlongWithKeyboard = false,
  Widget header = const SizedBox.shrink(),
  Locale? locale,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    builder: (context) => _builder(
      context,
      onSelect,
      favorite,
      exclude,
      countryFilter,
      showPhoneCode,
      countryListTheme,
      searchAutofocus,
      showWorldWide,
      showSearch,
      moveAlongWithKeyboard,
      customFlagBuilder,
      header,
      locale,
    ),
  ).whenComplete(() {
    if (onClosed != null) onClosed();
  });
}

Widget _builder(
  BuildContext context,
  ValueChanged<Country> onSelect,
  List<String>? favorite,
  List<String>? exclude,
  List<String>? countryFilter,
  bool showPhoneCode,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus,
  bool showWorldWide,
  bool showSearch,
  bool moveAlongWithKeyboard,
  CustomFlagBuilder? customFlagBuilder,
  Widget header,
  Locale? locale,
) {
  final device = MediaQuery.of(context).size.height;
  final statusBarHeight = MediaQuery.of(context).padding.top;
  final height = countryListTheme?.bottomSheetHeight ??
      device - (statusBarHeight + (kToolbarHeight / 1.5));
  final width = countryListTheme?.bottomSheetWidth;

  Color? _backgroundColor = countryListTheme?.backgroundColor ??
      Theme.of(context).bottomSheetTheme.backgroundColor;

  if (_backgroundColor == null) {
    if (Theme.of(context).brightness == Brightness.light) {
      _backgroundColor = Colors.white;
    } else {
      _backgroundColor = Colors.black;
    }
  }

  final BorderRadius _borderRadius = countryListTheme?.borderRadius ??
      const BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      );

  return Padding(
    padding: moveAlongWithKeyboard
        ? MediaQuery.of(context).viewInsets
        : EdgeInsets.zero,
    child: Container(
      height: height,
      width: width,
      padding: countryListTheme?.padding,
      margin: countryListTheme?.margin,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: _buildContent(
          header,
          onSelect,
          exclude,
          favorite,
          countryFilter,
          showPhoneCode,
          countryListTheme,
          searchAutofocus,
          showWorldWide,
          showSearch,
          customFlagBuilder,
          locale,
        ),
      ),
    ),
  );
}

Widget _buildContent(
  Widget header,
  ValueChanged<Country> onSelect,
  List<String>? exclude,
  List<String>? favorite,
  List<String>? countryFilter,
  bool showPhoneCode,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus,
  bool showWorldWide,
  bool showSearch,
  CustomFlagBuilder? customFlagBuilder,
  Locale? locale,
) {
  final content = Column(
    children: [
      header,
      Flexible(
        child: CountryListView(
          onSelect: onSelect,
          exclude: exclude,
          favorite: favorite,
          countryFilter: countryFilter,
          showPhoneCode: showPhoneCode,
          countryListTheme: countryListTheme,
          searchAutofocus: searchAutofocus,
          showWorldWide: showWorldWide,
          showSearch: showSearch,
          customFlagBuilder: customFlagBuilder,
          locale: locale,
        ),
      ),
    ],
  );

  // Wrap with Directionality if locale is provided and is RTL
  if (locale != null && _isRtlLocale(locale)) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: content,
    );
  }

  return content;
}
