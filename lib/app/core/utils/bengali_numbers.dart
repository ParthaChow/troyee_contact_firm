String toBengaliNumber(dynamic value) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  String text = value.toString();

  for (int i = 0; i < english.length; i++) {
    text = text.replaceAll(english[i], bengali[i]);
  }

  return text;
}

String formatBengaliDouble(
    double value, {
      int decimal = 1,
    }) {
  return toBengaliNumber(
    value.toStringAsFixed(decimal),
  );
}


String formatBengaliInt(int value) {
  return toBengaliNumber(value);
}