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

  final int _pageSize = 3; // Ekranda ilk başta 3 tane görünecek
  int _currentPage = 1;

  EventBloc() : super(EventInitial()) {
    on<FetchEventsEvent>(_onFetchEvents);
    on<LoadMoreEventsEvent>(_onLoadMoreEvents);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onFetchEvents(FetchEventsEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      if (_categories.isEmpty) {
        _categories = await _eventRepository.getCategories();
      }
      _favorites = await _favoriteRepository.getFavorites();

      _allEvents = await _eventRepository.getEvents();

      _currentPage = 1;
      List<EventModel> filtered = _applyFilters(_allEvents, event.search, event.categoryId);

      // İlk sayfa için sadece ilk 3 elemanı alıyoruz
      final paginatedList = filtered.take(_pageSize).toList();
      final hasMore = filtered.length > paginatedList.length;

      emit(EventLoaded(
        events: paginatedList,
        categories: _categories,
        favoriteIds: _favorites,
        selectedCategoryId: event.categoryId,
        searchQuery: event.search,
        hasMore: hasMore,
        isFetchingMore: false,
      ));
    } catch (e) {
      emit(EventError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMoreEvents(LoadMoreEventsEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      if (!currentState.hasMore || currentState.isFetchingMore) return;

      emit(currentState.copyWith(isFetchingMore: true));

      _currentPage++;
      List<EventModel> filtered = _applyFilters(_allEvents, currentState.searchQuery, currentState.selectedCategoryId);

      final nextItems = filtered.take(_currentPage * _pageSize).toList();
      final hasMore = filtered.length > nextItems.length;

      emit(currentState.copyWith(
        events: nextItems,
        hasMore: hasMore,
        isFetchingMore: false,
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
            e.description.toLowerCase().contains(searchQuery);
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