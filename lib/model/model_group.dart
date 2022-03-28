import 'package:hive/hive.dart';
part 'model_group.g.dart';

@HiveType(typeId: 0)
class StoredGroup extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<String> numbers;
}
