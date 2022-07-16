extension ListTextExtension on String {
  List<String> get listText {
    String text = "";
    final List<String> textList = <String>[];
    for (int i = 0; i < length; i++) {
      if (this[i] != '\n') {
        text += this[i];
        if (i == length - 1) {
          textList.add(text);
          text = "";
        }
        continue;
      }
      textList.add(text);
      text = "";
    }
    return textList;
  }
}
