import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Serviço responsável por carregar dinamicamente as fontes Libre Baskerville (serifada)
/// e IBM Plex Sans (sem serifa) no motor gráfico do Flutter.
class CarregadorFontes {
  const CarregadorFontes._();

  static Future<void> carregarFontesTipografia() async {
    Future<void> registrarFamilia({
      required String familia,
      required List<String> assetsLocais,
      required List<String> urlsFallback,
    }) async {
      try {
        final loader = FontLoader(familia);
        bool adicionou = false;

        for (final assetPath in assetsLocais) {
          try {
            final byteData = await rootBundle.load(assetPath);
            if (byteData.lengthInBytes > 0) {
              loader.addFont(Future.value(byteData));
              adicionou = true;
            }
          } catch (_) {
            // Se o asset ainda não estiver no bundle atual, tenta via URL abaixo
          }
        }

        if (!adicionou) {
          for (final url in urlsFallback) {
            final resp = await http.get(Uri.parse(url));
            if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
              final bytes = resp.bodyBytes;
              loader.addFont(
                Future.value(
                  ByteData.sublistView(bytes),
                ),
              );
              adicionou = true;
            }
          }
        }

        if (adicionou) {
          await loader.load();
        }
      } catch (e) {
        debugPrint('[LicitHub Fonts] Aviso ao carregar $familia: $e');
      }
    }

    await Future.wait([
      registrarFamilia(
        familia: 'Libre Baskerville',
        assetsLocais: const [
          'assets/fonts/LibreBaskerville-Regular.ttf',
          'assets/fonts/LibreBaskerville-Italic.ttf',
          'assets/fonts/LibreBaskerville-Bold.ttf',
        ],
        urlsFallback: const [
          'https://cdn.jsdelivr.net/fontsource/fonts/libre-baskerville@latest/latin-400-normal.ttf',
          'https://cdn.jsdelivr.net/fontsource/fonts/libre-baskerville@latest/latin-400-italic.ttf',
          'https://cdn.jsdelivr.net/fontsource/fonts/libre-baskerville@latest/latin-700-normal.ttf',
        ],
      ),
      registrarFamilia(
        familia: 'IBM Plex Sans',
        assetsLocais: const [
          'assets/fonts/IBMPlexSans-Regular.ttf',
          'assets/fonts/IBMPlexSans-Medium.ttf',
          'assets/fonts/IBMPlexSans-SemiBold.ttf',
          'assets/fonts/IBMPlexSans-Bold.ttf',
        ],
        urlsFallback: const [
          'https://cdn.jsdelivr.net/fontsource/fonts/ibm-plex-sans@latest/latin-400-normal.ttf',
          'https://cdn.jsdelivr.net/fontsource/fonts/ibm-plex-sans@latest/latin-500-normal.ttf',
          'https://cdn.jsdelivr.net/fontsource/fonts/ibm-plex-sans@latest/latin-600-normal.ttf',
          'https://cdn.jsdelivr.net/fontsource/fonts/ibm-plex-sans@latest/latin-700-normal.ttf',
        ],
      ),
    ]);
  }
}
