import 'dart:convert';

// {{
//   "title": "New Product",
//   "price": 100,
//   "description": "A description",
//   "CategoryName": "Fashion",
//   "images": [
//     "https://placeimg.com/640/480/any"
//   ]
// }

class ProductModel {
  final String title;
  final int price;
  final String description;
  final int categoryId;
  final List<String> images;
  ProductModel({
    required this.title,
    required this.price,
    required this.description,
    this.categoryId = 1,
    this.images = const ['https://api.lorem.space/image/fashion?w=150&h=150'],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': images,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] ?? '',
      price: map['price']?.toInt() ?? 0,
      description: map['description'] ?? '',
      categoryId: map['categoryId']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
