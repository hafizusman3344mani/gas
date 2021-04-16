class RouteSingleton {

  int currentScreen = 0;
  RouteSingleton._privateConstructor();

  static final RouteSingleton _instance = RouteSingleton._privateConstructor();

  static RouteSingleton get instance => _instance;
}
