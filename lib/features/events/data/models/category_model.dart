class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CategoryModel(
        id: json['id']?.toString() ?? json['name']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
    } else {
      // Eğer kategori API'den sadece 'Hackathon' gibi bir String olarak dönüyorsa:
      return CategoryModel(
        id: json.toString(),
        name: json.toString(),
      );
    }
  }
}