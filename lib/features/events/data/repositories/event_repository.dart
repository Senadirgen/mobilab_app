import 'package:mobilab_app/core/network/api_client.dart';
import '../models/event_model.dart';
import '../models/category_model.dart';

class EventRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');
      final listData = _extractList(response.data);
      return listData.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<EventModel>> getEvents({String? search, String? categoryId}) async {
    final Map<String, dynamic> queryParams = {
      'limit': 50,
      'per_page': 50,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null && categoryId.isNotEmpty) queryParams['category_id'] = categoryId;

    try {
      final response = await _apiClient.get('/events', queryParameters: queryParams);
      List<dynamic> listData = _extractList(response.data);

      if (listData.length == 10) {
        try {
          final queryParamsPage2 = Map<String, dynamic>.from(queryParams);
          queryParamsPage2['page'] = 2;
          final responsePage2 = await _apiClient.get('/events', queryParameters: queryParamsPage2);
          final listDataPage2 = _extractList(responsePage2.data);
          listData = [...listData, ...listDataPage2];
        } catch (_) {}
      }

      return listData.map((e) => EventModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> getEventDetail(String eventId) async {
    final response = await _apiClient.get('/events/$eventId');
    Map<String, dynamic> data = {};
    if (response.data is Map<String, dynamic>) {
      data = response.data['data'] ?? response.data['event'] ?? response.data;
    }
    return EventModel.fromJson(data);
  }

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) {
      return responseData;
    } else if (responseData is Map) {
      for (var key in ['data', 'categories', 'events', 'items', 'result', 'results']) {
        if (responseData.containsKey(key) && responseData[key] is List) {
          return responseData[key];
        }
      }
    }
    return [];
  }
}