import 'package:demo/core/db/base_local_source.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductLocalSource extends BaseLocalSource {
  ProductLocalSource(super.appDatabase);

  Future<List<Map<String, Object?>>> getFavoriteProducts() async {
    final db = await appDatabase.db;
    return db.query('fav_products');
  }

  Future<int> addFavorite(int id) async {
    final db = await appDatabase.db;
    return db.insert('fav_products', {
      'id': id,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> removeFavorite(int id) async {
    final db = await appDatabase.db;
    final count = await db.delete(
      'fav_products',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count == 1;
  }
}
