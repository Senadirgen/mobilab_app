import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final EventRepository _eventRepository = EventRepository();
  late Future<EventModel> _eventDetailFuture;

  @override
  void initState() {
    super.initState();
    _eventDetailFuture = _eventRepository.getEventDetail(widget.event.id).catchError((_) {
      return widget.event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: FutureBuilder<EventModel>(
        future: _eventDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final event = snapshot.data ?? widget.event;
          
          final descriptionText = (event.description.trim().isNotEmpty)
              ? event.description
              : 'Bu etkinlik için henüz bir açıklama eklenmemiştir.';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      event.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 220,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.event, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (event.date != null && event.date!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          event.date!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                if (event.location != null && event.location!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Text(
                          event.location!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 32),
                const Text(
                  'Etkinlik Hakkında',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  descriptionText,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}