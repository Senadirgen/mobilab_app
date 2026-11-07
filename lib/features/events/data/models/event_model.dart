class EventModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String? imageUrl;
  final String? date;
  final String? location;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    this.imageUrl,
    this.date,
    this.location,
  });

  factory EventModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // API'den gelebilecek tarih ve saat ile ilgili tüm muhtemel key'leri kontrol ediyoruz
      dynamic rawDate = json['date'] ??
          json['event_date'] ??
          json['start_date'] ??
          json['startDate'] ??
          json['date_time'] ??
          json['dateTime'] ??
          json['time'] ??
          json['created_at'];

      String? parsedDate;
      if (rawDate != null) {
        final strDate = rawDate.toString().trim();
        if (strDate.isNotEmpty && strDate != 'null') {
          // Eğer ISO 8601 formatında geldiyse (örn: 2024-11-15T14:30:00Z) daha okunabilir parçalayalım
          if (strDate.contains('T')) {
            try {
              final dt = DateTime.parse(strDate);
              parsedDate = "${dt.day}.${dt.month}.${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
            } catch (_) {
              parsedDate = strDate;
            }
          } else {
            parsedDate = strDate;
          }
        }
      }

      // Konum için kontroller
      dynamic rawLocation = json['location'] ??
          json['venue'] ??
          json['place'] ??
          json['address'];

      String? parsedLocation;
      if (rawLocation != null && rawLocation.toString().trim().isNotEmpty) {
        parsedLocation = rawLocation.toString().trim();
      }

      return EventModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        categoryId: json['category_id']?.toString() ??
            json['categoryId']?.toString() ??
            json['category']?.toString() ??
            '',
        imageUrl: json['image_url']?.toString() ??
            json['imageUrl']?.toString() ??
            json['image']?.toString(),
        date: parsedDate,
        location: parsedLocation,
      );
    }
    return EventModel(
      id: '',
      title: json.toString(),
      description: '',
      categoryId: '',
    );
  }
}