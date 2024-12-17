// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilmAdapter extends TypeAdapter<Film> {
  @override
  final int typeId = 2;

  @override
  Film read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Film(
      title: fields[0] as String,
      poster: fields[1] as String,
      myRating: fields[2] as double,
      imdbRating: fields[3] as double,
      plot: fields[4] as String,
      year: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Film obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.poster)
      ..writeByte(2)
      ..write(obj.myRating)
      ..writeByte(3)
      ..write(obj.imdbRating)
      ..writeByte(4)
      ..write(obj.plot)
      ..writeByte(5)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
