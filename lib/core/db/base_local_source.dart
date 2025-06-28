import 'package:demo/core/db/database.dart';

abstract class BaseLocalSource {
  final AppDatabase appDatabase;

  BaseLocalSource(this.appDatabase);
}
