import 'package:hive_flutter/adapters.dart';

part 'post_info_model.g.dart';

@HiveType(typeId: 0)
class PostInfo extends HiveObject {
  PostInfo(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body});

  PostInfo get copy {
    PostInfo objectInstance =
        PostInfo(title: title, id: id, body: body, userId: userId);
    return objectInstance;
  }

  @HiveField(0)
  int id;

  @HiveField(1)
  int userId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String body;
}
