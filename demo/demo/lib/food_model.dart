import 'package:json_annotation/json_annotation.dart';

part 'food_model.g.dart';

String forceString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

@JsonSerializable()
class Chef {
  final String name;
  @JsonKey(name: 'experience_years')
  final int experience;

  Chef({required this.name, required this.experience});

  factory Chef.fromJson(Map<String, dynamic> json) => _$ChefFromJson(json);
  Map<String, dynamic> toJson() => _$ChefToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FoodItem {
  @JsonKey(fromJson: forceString)
  final String id;

  final String name;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> tags;
  final Chef chef;

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.tags,
    required this.chef,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}
