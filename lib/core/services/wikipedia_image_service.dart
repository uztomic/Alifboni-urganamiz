import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fetches a real photo for an animal/plant from Wikipedia's public,
/// keyless REST summary API (no scraping, no hardcoded/fragile image
/// URLs — the API resolves the current lead photo for us). Results are
/// cached in memory for the life of the app since the same ~20 titles
/// are looked up repeatedly across Nature screens.
class WikipediaImageService {
  WikipediaImageService._();
  static final WikipediaImageService instance = WikipediaImageService._();

  final Map<String, String?> _cache = {};

  /// Returns a direct image URL for [wikipediaTitle] (the English article
  /// title, e.g. "Lion", "Sunflower"), or null if it couldn't be fetched
  /// (offline, article missing a lead image, etc.).
  ///
  /// Uses the classic MediaWiki action API with `pithumbsize` rather than
  /// the REST summary endpoint + a hand-rolled "bump the width in the
  /// thumb URL" hack — Wikimedia's image CDN only serves a fixed list of
  /// preset widths for a given cached thumb URL and returns HTTP 400 for
  /// anything else, while `pithumbsize` is the officially supported way
  /// to request an arbitrary rendition size.
  Future<String?> fetchThumbnail(String wikipediaTitle) async {
    if (_cache.containsKey(wikipediaTitle)) return _cache[wikipediaTitle];

    try {
      final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'titles': wikipediaTitle,
        'prop': 'pageimages',
        'format': 'json',
        'formatversion': '2',
        'pithumbsize': '720',
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final pages = (data['query'] as Map<String, dynamic>?)?['pages'] as List<dynamic>?;
        final thumbnail = pages != null && pages.isNotEmpty
            ? (pages.first as Map<String, dynamic>)['thumbnail'] as Map<String, dynamic>?
            : null;
        final url = thumbnail?['source'] as String?;
        _cache[wikipediaTitle] = url;
        return url;
      }
    } catch (_) {
      // Offline or request failed — caller falls back to an emoji/icon.
    }
    _cache[wikipediaTitle] = null;
    return null;
  }
}
