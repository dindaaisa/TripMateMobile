import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'landing_page_model.g.dart';

@HiveType(typeId: 1)
class LandingPageModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  Uint8List? imageBytes;

  LandingPageModel({
    required this.title,
    required this.description,
    this.imageBytes,
  });
}
