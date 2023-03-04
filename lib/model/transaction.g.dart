// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction()
      ..cities = (fields[0] as List).cast<dynamic>()
      ..offers = (fields[1] as List).cast<dynamic>()
      ..brands = (fields[2] as List).cast<dynamic>()
      ..brandsCountry = (fields[3] as List).cast<dynamic>()
      ..suplierList = (fields[4] as List).cast<dynamic>()
      ..ordersList = (fields[5] as List).cast<dynamic>()
      ..userData = (fields[6] as Map).cast<dynamic, dynamic>()
      ..userInfo = (fields[7] as Map).cast<dynamic, dynamic>();
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.cities)
      ..writeByte(1)
      ..write(obj.offers)
      ..writeByte(2)
      ..write(obj.brands)
      ..writeByte(3)
      ..write(obj.brandsCountry)
      ..writeByte(4)
      ..write(obj.suplierList)
      ..writeByte(5)
      ..write(obj.ordersList)
      ..writeByte(6)
      ..write(obj.userData)
      ..writeByte(7)
      ..write(obj.userInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
