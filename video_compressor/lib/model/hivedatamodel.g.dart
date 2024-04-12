// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hivedatamodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoHistoryAdapter extends TypeAdapter<VideoHistory> {
  @override
  final int typeId = 0;

  @override
  VideoHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoHistory(
      originalPath: fields[0] as String,
      compressedPath: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VideoHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.originalPath)
      ..writeByte(1)
      ..write(obj.compressedPath)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
