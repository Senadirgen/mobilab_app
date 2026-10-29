import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEventsEvent extends EventEvent {
  final String? search;
  final String? categoryId;

  FetchEventsEvent({this.search, this.categoryId});

  @override
  List<Object?> get props => [search, categoryId];
}

class LoadMoreEventsEvent extends EventEvent {}

class ToggleFavoriteEvent extends EventEvent {
  final String eventId;

  ToggleFavoriteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}