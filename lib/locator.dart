import 'package:clickup/data/providers/db.dart';
import 'package:get_it/get_it.dart';

import 'data/providers/api.dart';

String get apiKey => "pk_6816877_SJDXPHVD1P8FX8UL342D3HGMJT53EB07";

final GetIt locator = GetIt.instance;

registerServices() {
  locator.registerLazySingleton(() => ClickUpApi(apiKey));
  locator.registerLazySingleton(() => DBProvider());
}
