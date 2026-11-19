import 'package:flutter/services.dart';

/// Emoji o'rniga ishlatiladigan 3D rasmlar (assets/pictures, Microsoft
/// Fluent Emoji 3D, MIT litsenziya). Ilova ichida — internet kerak emas va
/// eski telefonlarda emoji "kvadrat" bo'lib ko'rinmaydi.
class Pictures {
  Pictures._();
  static final Set<String> _keys = {};

  static Future<void> init() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      for (final p in manifest.listAssets()) {
        if (p.startsWith('assets/pictures/')) {
          _keys.add(p.substring('assets/pictures/'.length).split('.').first);
        }
      }
    } catch (_) {}
  }

  static String keyOf(String emoji) => emoji.runes
      .where((c) => c != 0xFE0F)
      .map((c) => c.toRadixString(16))
      .join('_');

  /// Rasm yo'li yoki `null` (bunda emoji matn sifatida chiziladi).
  static String? assetFor(String emoji) {
    if (emoji.isEmpty) return null;
    final k = keyOf(emoji);
    return _keys.contains(k) ? 'assets/pictures/$k.webp' : null;
  }
}
