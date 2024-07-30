class RelativeSize {
  static double width(double absWidth, double width) {
    return (absWidth / 414) * width;
  }

  static double height(double absHeight, double height) {
    return (absHeight / 736) * height;
  }
}
