import 'package:flutter/material.dart';

/// Configurações centralizadas de tema, cores, modo noturno/claro e usabilidade do LicitHub.
class TemaApp {
  const TemaApp._();

  static const String fonteSerifada = 'Libre Baskerville';
  static const String fonteSemSerifa = 'IBM Plex Sans';

  static const List<String> fallbackSerifada = [
    'Georgia',
    'Times New Roman',
    'serif',
  ];

  static const List<String> fallbackSemSerifa = [
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

  /// Estado reativo global do modo de tema (Claro / Noturno).
  static final ValueNotifier<ThemeMode> modoTema =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Estado reativo global da escala de fonte para acessibilidade/usabilidade (ex: 1.0, 1.1, 1.2).
  static final ValueNotifier<double> escalaFonte = ValueNotifier<double>(1.0);

  /// Estado reativo para modo de alto contraste nas bordas e textos.
  static final ValueNotifier<bool> altoContraste = ValueNotifier<bool>(false);

  static bool get isModoNoturno => modoTema.value == ThemeMode.dark;

  static void alternarModoTema() {
    modoTema.value =
        modoTema.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  static void definirModoNoturno(bool ativar) {
    modoTema.value = ativar ? ThemeMode.dark : ThemeMode.light;
  }

  // Helpers de cores adaptativas (Claro vs Noturno)
  static Color corFundoPainel(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0B1120)
          : const Color(0xFFF4F7F9);

  static Color corSuperficieCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E293B)
          : Colors.white;

  static Color corSuperficieSecundaria(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC);

  static Color corBordaCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (altoContraste.value) {
      return isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
    }
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }

  static Color corTextoPrincipal(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF1E293B);

  static Color corTextoSecundario(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF94A3B8)
          : const Color(0xFF64748B);

  static ThemeData obterTemaClaro() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fonteSemSerifa,
      fontFamilyFallback: fallbackSemSerifa,
      scaffoldBackgroundColor: const Color(0xFFF8FAFE),
      primaryColor: const Color(0xFF0F172A),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: fonteSemSerifa,
          color: Color(0xFF334155),
        ),
        bodyMedium: TextStyle(
          fontFamily: fonteSemSerifa,
          color: Color(0xFF334155),
        ),
        labelLarge: TextStyle(
          fontFamily: fonteSemSerifa,
        ),
      ),
    );
  }

  static ThemeData obterTemaEscuro() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fonteSemSerifa,
      fontFamilyFallback: fallbackSemSerifa,
      scaffoldBackgroundColor: const Color(0xFF0B1120),
      primaryColor: const Color(0xFF3B82F6),
      cardColor: const Color(0xFF1E293B),
      dividerColor: const Color(0xFF334155),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: fonteSemSerifa,
          color: Color(0xFFE2E8F0),
        ),
        bodyMedium: TextStyle(
          fontFamily: fonteSemSerifa,
          color: Color(0xFFCBD5E1),
        ),
        labelLarge: TextStyle(
          fontFamily: fonteSemSerifa,
        ),
      ),
    );
  }
}
