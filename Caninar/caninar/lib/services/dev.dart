class Dev {
  static bool isDev = !const bool.fromEnvironment('dart.vm.product');
}
