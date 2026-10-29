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
      return EventModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        categoryId: json['category_id']?.toString() ?? json['categoryId']?.toString() ?? json['category']?.toString() ?? '',
        imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString() ?? json['image']?.toString(),
        date: json['date']?.toString(),
        location: json['location']?.toString(),
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