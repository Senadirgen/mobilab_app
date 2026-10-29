import 'package:equatable/equatable.dart';
import '../../data/models/event_model.dart';
import '../../data/models/category_model.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<EventModel> events;
  final List<CategoryModel> categories;
  final List<String> favoriteIds;
  final String? selectedCategoryId;
  final String? searchQuery;
  final bool hasMore;
  final bool isFetchingMore;

  EventLoaded({
    required this.events,
    required this.categories,
    required this.favoriteIds,
    this.selectedCategoryId,
    this.searchQuery,
    this.hasMore = false,
    this.isFetchingMore = false,
  });

  EventLoaded copyWith({
    List<EventModel>? events,
    List<CategoryModel>? categories,
    List<String>? favoriteIds,
    String? selectedCategoryId,
    String? searchQuery,
    bool? hasMore,
    bool? isFetchingMore,
  }) {
    return EventLoaded(
      events: events ?? this.events,
      categories: categories ?? this.categories,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        events,
        categories,
        favoriteIds,
        selectedCategoryId,
        searchQuery,
        hasMore,
        isFetchingMore,
      ];
}

class EventError extends EventState {
  final String message;

  EventError(this.message);

  @override
  List<Object?> get props => [message];
}