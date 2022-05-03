import 'package:get_it/get_it.dart';

import 'Helper.dart';
GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerSingleton(AppDatabase(openConnection()));
}