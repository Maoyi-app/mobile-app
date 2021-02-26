import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:***REMOVED***/entities/image.dart';

part 'commodity.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Commodity {
  num id;
  String name;
  ImageData commodityImage;

  Commodity({this.id, this.name, this.commodityImage});

  Image getImage() {
    return Image.network(
        "https://images.pexels.com/photos/3640451/pexels-photo-3640451.jpeg");
  }

  factory Commodity.fromJson(Map<String, dynamic> json) =>
      _$CommodityFromJson(json);
  Map<String, dynamic> toJson() => _$CommodityToJson(this);

  static fromJsonList(List list) {
    if (list == null) return List();
    return list.map((e) => Commodity.fromJson(e)).toList();
  }

  String commodityAsString() {
    return '#${this.id} ${this.name}';
  }

  bool isEqual(Commodity commodity) {
    return this?.id == commodity?.id;
  }

  bool filterByName(String filter) {
    return this?.name?.toLowerCase()?.contains(filter);
  }

  @override
  String toString() => name;
}
