import 'package:flutter/services.dart';

/// Pre-loads TTF font bytes on the main thread for safe transfer to
/// the background PDF worker isolate. Ensures zero missing glyphs for
/// Turkish Unicode characters (ğ, Ü, Ş, İ, ö, ç) in vector PDFs.
class FontByteLoader {
  static Uint8List? _interRegular;
  static Uint8List? _interBold;
  static Uint8List? _notoSansRegular;
  static Uint8List? _notoSansBold;
  static Uint8List? _robotoRegular;
  static Uint8List? _robotoItalic;

  static bool _isLoaded = false;

  /// Pre-loads all bundled font assets from rootBundle.
  /// Must be called on the main thread before spawning the PDF isolate.
  static Future<void> preload() async {
    if (_isLoaded) return;

    _interRegular = await _load('assets/fonts/Inter-Regular.ttf');
    _interBold = await _load('assets/fonts/Inter-Bold.ttf');
    _notoSansRegular = await _load('assets/fonts/NotoSans-Regular.ttf');
    _notoSansBold = await _load('assets/fonts/NotoSans-Bold.ttf');
    _robotoRegular = await _load('assets/fonts/Roboto-Regular.ttf');
    _robotoItalic = await _load('assets/fonts/Roboto-Italic.ttf');

    _isLoaded = true;
  }

  static Future<Uint8List> _load(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  /// Returns all loaded font bytes grouped by font family for isolate transfer
  static Map<String, Map<String, Uint8List>> getFontBytesMap() {
    assert(_isLoaded, 'FontByteLoader.preload() must be called before accessing fonts.');
    return {
      'inter': {
        'regular': _interRegular!,
        'bold': _interBold!,
      },
      'notoSans': {
        'regular': _notoSansRegular!,
        'bold': _notoSansBold!,
      },
      'roboto': {
        'regular': _robotoRegular!,
        'italic': _robotoItalic!,
      },
    };
  }

  /// Convenience getters for default font pair (Inter)
  static Uint8List get interRegular => _interRegular!;
  static Uint8List get interBold => _interBold!;
}
