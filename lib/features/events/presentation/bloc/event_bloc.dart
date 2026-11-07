import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/favorite_repository.dart';
import '../../data/models/category_model.dart';
import '../../data/models/event_model.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository = EventRepository();
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  List<CategoryModel> _categories = [];
  List<EventModel> _allEvents = [];
  List<String> _favorites = [];

  EventBloc() : super(EventInitial()) {
    on<FetchEventsEvent>(_onFetchEvents);
    on<FilterEventsEvent>(_onFilterEvents);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onFetchEvents(FetchEventsEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      if (_categories.isEmpty) {
        _categories = await _eventRepository.getCategories();
      }
      _favorites = await _favoriteRepository.getFavorites();
      
      // İlk yüklemede verileri çekip hafızaya alıyoruz
      _allEvents = await _eventRepository.getEvents();

      List<EventModel> filtered = _applyFilters(_allEvents, event.search, event.categoryId);

      emit(EventLoaded(
        events: filtered,
        categories: _categories,
        favoriteIds: _favorites,
        selectedCategoryId: event.categoryId,
        searchQuery: event.search,
      ));
    } catch (e) {
      emit(EventError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Arama metni değiştiğinde ağa istek atmadan önbellekteki `_allEvents` üzerinden süzer
  void _onFilterEvents(FilterEventsEvent event, Emitter<EventState> emit) {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      List<EventModel> filtered = _applyFilters(_allEvents, event.search, event.categoryId);

      emit(currentState.copyWith(
        events: filtered,
        selectedCategoryId: event.categoryId,
        searchQuery: event.search,
      ));
    }
  }

  List<EventModel> _applyFilters(List<EventModel> list, String? search, String? categoryId) {
    List<EventModel> filtered = List.from(list);

    if (categoryId != null && categoryId.isNotEmpty) {
      final catQuery = categoryId.toLowerCase();
      filtered = filtered.where((e) {
        final eCat = e.categoryId.toLowerCase();
        return eCat == catQuery || eCat.contains(catQuery) || catQuery.contains(eCat);
      }).toList();
    }

    if (search != null && search.isNotEmpty) {
      final searchQuery = search.toLowerCase();
      filtered = filtered.where((e) {
        return e.title.toLowerCase().contains(searchQuery) ||
            e.description.toLowerCase().contains(searchQuery) ||
            (e.location != null && e.location!.toLowerCase().contains(searchQuery));
      }).toList();
    }

    return filtered;
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      final updatedFavorites = await _favoriteRepository.toggleFavorite(event.eventId);

      emit(currentState.copyWith(favoriteIds: updatedFavorites));
    }
  }
}