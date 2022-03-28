part of 'model_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoredGroupAdapter extends TypeAdapter<StoredGroup> {
  @override
  final int typeId = 0;

  @override
  StoredGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoredGroup()
      ..name = fields[0] as String
      ..numbers = (fields[1] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, StoredGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.numbers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoredGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
