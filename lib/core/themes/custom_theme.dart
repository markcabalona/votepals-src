import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votepals/core/constants/padding.dart';
import 'package:votepals/core/themes/custom_colors.dart';

abstract class CustomTheme {
  static final theme = ThemeData(
    colorSchemeSeed: CustomColors.primary,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      fillColor: CustomColors.gray,
      filled: true,
      
      prefixIconColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      hintStyle: const TextStyle(color: CustomColors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        disabledBackgroundColor: CustomColors.lightGray,
        disabledForegroundColor: CustomColors.primary,
        backgroundColor: CustomColors.primary,
        foregroundColor: CustomColors.white,
        padding: const EdgeInsets.all(CustomPaddings.large),
        minimumSize: const Size(0, 55),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          disabledBackgroundColor: CustomColors.gray,
          disabledForegroundColor: CustomColors.white,
          backgroundColor: Colors.transparent,
          foregroundColor: CustomColors.primary,
          padding: const EdgeInsets.all(CustomPaddings.large),
          minimumSize: const Size(0, 55),
          side: const BorderSide(
            color: CustomColors.primary,
            width: 1,
            style: BorderStyle.solid,
          )),
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: kIsWeb
          ? {
              for (final platform in TargetPlatform.values)
                platform: const NoTransitionsBuilder(),
            }
          : const {
              // handle other platforms
            },
    ),
  );
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return FadeTransition(
      opacity: animation,
      child: child!,
    );
  }
}
