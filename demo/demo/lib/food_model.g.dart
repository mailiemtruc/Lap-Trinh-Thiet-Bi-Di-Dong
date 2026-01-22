// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chef _$ChefFromJson(Map<String, dynamic> json) => Chef(
  name: json['name'] as String,
  experience: (json['experience_years'] as num).toInt(),
);

Map<String, dynamic> _$ChefToJson(Chef instance) => <String, dynamic>{
  'name': instance.name,
  'experience_years': instance.experience,
};

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
  id: forceString(json['id']),
  name: json['name'] as String,
  imageUrl: json['image_url'] as String,
  price: (json['price'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  chef: Chef.fromJson(json['chef'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image_url': instance.imageUrl,
  'price': instance.price,
  'rating': instance.rating,
  'tags': instance.tags,
  'chef': instance.chef.toJson(),
};
