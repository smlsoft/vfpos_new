enum Flavor {
  DEV,
  DEDEPOS,
  SMLSUPERPOS,
  SMLMOBILESALES,
  VFPOS,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'DEDE POS';
      case Flavor.DEDEPOS:
        return 'DEDE POS';
      case Flavor.SMLSUPERPOS:
        return 'SML Super POS';
      case Flavor.SMLMOBILESALES:
        return 'SML Mobile Sales';
      case Flavor.VFPOS:
        return 'Village Fund POS';
      default:
        return 'title';
    }
  }

}
