import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/check_model.dart';
part 'Helper.g.dart';

class Helper extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productImage => text()();
  TextColumn get productTitle => text()();
  TextColumn get productPrice => text()();
  TextColumn get productDescription => text()();
  TextColumn get totalPrice => text()();
  TextColumn get totalQuantity => text()();
  TextColumn get productId => text()();
  TextColumn get productCategory => text()();
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Helper])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // Queries
  // Get all users
  Future<List<HelperData>> getAllUsers() => select(helper).get();

  // Add user
  Future insertUser(HelperData user) => into(helper).insert(user);

  // Update user
  Future updateUser(HelperData user) => update(helper).replace(user);

  // Delete user
  Future deleteUser(HelperData user) => delete(helper).delete(user);

  // delete all users
  Future deleteAllProducts() => delete(helper).go();
}