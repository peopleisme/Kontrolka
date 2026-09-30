// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todoList_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class todoListAdapter extends TypeAdapter<todoList> {
  @override
  final int typeId = 3;

  @override
  todoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return todoList(
      name: fields[0] as String,
      date: fields[1] as String,
      isDaily: fields[2] as bool,
      taskList: (fields[3] as List).cast<Task>(),
    );
  }

  @override
  void write(BinaryWriter writer, todoList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isDaily)
      ..writeByte(3)
      ..write(obj.taskList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is todoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
