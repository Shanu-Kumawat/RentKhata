import 'package:drift/drift.dart';
import 'property_table.dart';
import 'room_table.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  // Store as string enum or integer; let's stick to integer mapping or string
  TextColumn get category => text()(); 
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  
  // Optional relations
  IntColumn get propertyId =>
      integer().nullable().references(Properties, #id, onDelete: KeyAction.setNull)();
  IntColumn get roomId =>
      integer().nullable().references(Rooms, #id, onDelete: KeyAction.setNull)();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
