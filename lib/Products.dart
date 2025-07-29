class Products {
  Products({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? slug;
  final int? price;
  final String? description;
  final Category? category;
  final List<String> images;
  final DateTime? creationAt;
  final DateTime? updatedAt;

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      price: json["price"],
      description: json["description"],
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
      creationAt: DateTime.tryParse(json["creationAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      id: map['id'],
      title: map['title'],
      slug: map['slug'],
      price: map['price'],
      description: map['description'],
      category: map['category'] != null ? Category.fromMap(map['category']) : null,
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      creationAt: map['creationAt'] != null ? DateTime.tryParse(map['creationAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  bool operator ==(Object other) =>
      identical(this, other) || (other is Products && id == other.id);

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category != null ? {
        'id': category!.id,
        'name': category!.name,
        'slug': category!.slug,
        'image': category!.image,
        'creationAt': category!.creationAt?.toIso8601String(),
        'updatedAt': category!.updatedAt?.toIso8601String(),
      } : null,
      'images': images,
      'creationAt': creationAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? image;
  final DateTime? creationAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      image: json["image"],
      creationAt: DateTime.tryParse(json["creationAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      image: map['image'],
      creationAt: map['creationAt'] != null ? DateTime.tryParse(map['creationAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }
}