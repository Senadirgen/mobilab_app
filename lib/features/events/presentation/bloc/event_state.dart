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

  EventLoaded({
    required this.events,
    required this.categories,
    required this.favoriteIds,
    this.selectedCategoryId,
    this.searchQuery,
  });

  EventLoaded copyWith({
    List<EventModel>? events,
    List<CategoryModel>? categories,
    List<String>? favoriteIds,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return EventLoaded(
      events: events ?? this.events,
      categories: categories ?? this.categories,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        events,
        categories,
        favoriteIds,
        selectedCategoryId,
        searchQuery,
      ];
}

class EventError extends EventState {
  final String message;

  EventError(this.message);

  @override
  List<Object?> get props => [message];
}