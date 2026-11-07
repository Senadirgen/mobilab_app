import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/event_card.dart';
import 'event_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Etkinliklerim'),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          // State kontrolü eklenerek getter hataları çözüldü
          if (state is EventLoaded) {
            final favoriteEvents = state.events
                .where((event) => state.favoriteIds.contains(event.id))
                .toList();

            if (favoriteEvents.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Henüz favori etkinlik eklemediniz.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                final event = favoriteEvents[index];
                return EventCard(
                  event: event,
                  isFavorite: true,
                  // Parametre ismi onFavoriteToggle olarak düzeltildi
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}