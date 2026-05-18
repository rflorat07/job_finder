extension CompactNumberExtension on double {
  String toCompactFormat() {
    if (this >= 1000000000) {
      return '${(this / 1000000000)._cleanDecimal()}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000)._cleanDecimal()}M';
    } else if (this >= 1000) {
      return '${(this / 1000)._cleanDecimal()}K';
    }
    return toStringAsFixed(0); // Less than 1000 is shown normally
  }

  // Private helper method to avoid outputting "9.0K", leaving just "9K".
  // But if the value is "9.5", it will keep it as "9.5K".
  String _cleanDecimal() {
    return toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }
}
