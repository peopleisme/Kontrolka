// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProblemAdapter extends TypeAdapter<Problem> {
  @override
  final int typeId = 1;

  @override
  Problem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Problem(
      title: fields[0] as String,
      type: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Problem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
