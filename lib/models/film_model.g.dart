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
      seen: fields[0] as bool,
      title: fields[1] as String,
      poster: fields[2] as String,
      myRating: fields[3] as double,
      imdbRating: fields[4] as double,
      plot: fields[5] as String,
      year: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Film obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.seen)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.poster)
      ..writeByte(3)
      ..write(obj.myRating)
      ..writeByte(4)
      ..write(obj.imdbRating)
      ..writeByte(5)
      ..write(obj.plot)
      ..writeByte(6)
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
