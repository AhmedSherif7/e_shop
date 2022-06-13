import '../../domain/entities/category.dart';
import '../mappers/mapper.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    required String image,
  }) : super(
          id: id,
          name: name,
          image: image,
        );

  factory CategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return CategoryModel(
        id: (json['id'] as String?).orEmpty(),
        name: (json['name'] as String?).orEmpty(),
        image: (json['image'] as String?).orEmpty(),
      );
    }
    return const CategoryModel(
      id: emptyString,
      name: emptyString,
      image: emptyString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory CategoryModel.empty() {
    return const CategoryModel(
      id: emptyString,
      name: emptyString,
      image: emptyString,
    );
  }
}
