import '../../domain/entities/product.dart';
import '../mappers/mapper.dart';
import 'category_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required double discount,
    required double rate,
    required int countInStock,
    required CategoryModel category,
    required String brand,
    required List<String> images,
    required String color,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          discount: discount,
          rate: rate,
          countInStock: countInStock,
          category: category,
          brand: brand,
          images: images,
          color: color,
        );

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return ProductModel(
        id: (json['id'] as String?).orEmpty(),
        name: (json['name'] as String?).orEmpty(),
        description: (json['description'] as String?).orEmpty(),
        price: ((json['price'] as num?)?.toDouble()).orEmpty(),
        discount: ((json['discount'] as num?)?.toDouble()).orEmpty(),
        rate: ((json['rate'] as num?)?.toDouble()).orEmpty(),
        countInStock: ((json['countInStock'] as num?)?.toInt()).orEmpty(),
        category:
            CategoryModel.fromJson(json['category'] as Map<String, dynamic>?),
        brand: (json['brand'] as String?).orEmpty(),
        images: toStringList(json['images'] as List<dynamic>?),
        color: (json['color'] as String?).orEmpty(),
      );
    }
    return ProductModel(
      id: emptyString,
      name: emptyString,
      description: emptyString,
      price: zeroDouble,
      discount: zeroDouble,
      rate: zeroDouble,
      countInStock: zeroInt,
      category: CategoryModel.empty(),
      brand: emptyString,
      images: const [],
      color: emptyString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'rate': rate,
      'countInStock': countInStock,
      'category': (category as CategoryModel).toJson(),
      'brand': brand,
      'images': images,
      'color': color,
    };
  }
}

List<String> toStringList(List<dynamic>? list) {
  if (list != null) {
    return list.map((imageUrl) {
      if (imageUrl != null) {
        return imageUrl.toString();
      }
      return emptyString;
    }).toList();
  }
  return [];
}
