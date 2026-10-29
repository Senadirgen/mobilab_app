import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepository {
  static const String _key = 'favorite_event_ids';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<List<String>> toggleFavorite(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    if (favorites.contains(eventId)) {
      favorites.remove(eventId);
    } else {
      favorites.add(eventId);
    }

    await prefs.setStringList(_key, favorites);
    return favorites;
  }
}