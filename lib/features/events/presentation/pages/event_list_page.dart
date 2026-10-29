import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'event_detail_page.dart';

class EventListPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const EventListPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String? selectedCategoryId;
  String currentSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Keşfi'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
            tooltip: 'Temayı Değiştir',
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama Arayüzü
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Etkinlik ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (query) {
                currentSearchQuery = query;
                context.read<EventBloc>().add(FetchEventsEvent(
                      search: query,
                      categoryId: selectedCategoryId,
                    ));
              },
            ),
          ),

          // Kategori Chips
          BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoaded && state.categories.isNotEmpty) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FilterChip(
                          label: const Text('Tümü'),
                          selected: selectedCategoryId == null,
                          onSelected: (selected) {
                            setState(() => selectedCategoryId = null);
                            context.read<EventBloc>().add(FetchEventsEvent(
                                  search: currentSearchQuery,
                                  categoryId: null,
                                ));
                          },
                        ),
                      ),
                      ...state.categories.map((cat) {
                        final isSelected = selectedCategoryId == cat.name;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: FilterChip(
                            label: Text(cat.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategoryId = selected ? cat.name : null;
                              });
                              context.read<EventBloc>().add(FetchEventsEvent(
                                    search: currentSearchQuery,
                                    categoryId: selectedCategoryId,
                                  ));
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Etkinlik Listesi & "Daha Fazla Yükle" Butonu
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return const LoadingWidget();
                } else if (state is EventError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<EventBloc>().add(FetchEventsEvent());
                    },
                  );
                } else if (state is EventLoaded) {
                  if (state.events.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Etkinlik bulunamadı.'),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.events.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Eğer listenin sonundaysak ve yüklenmeyi bekleyen daha fazla eleman varsa "Daha Fazla Yükle" butonunu göster
                      if (index == state.events.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          child: state.isFetchingMore
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Daha Fazla Yükle'),
                                  onPressed: () {
                                    context.read<EventBloc>().add(LoadMoreEventsEvent());
                                  },
                                ),
                        );
                      }

                      final event = state.events[index];
                      final isFav = state.favoriteIds.contains(event.id);
                      return EventCard(
                        event: event,
                        isFavorite: isFav,
                        onFavoriteToggle: () {
                          context.read<EventBloc>().add(ToggleFavoriteEvent(event.id));
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailPage(event: event),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}