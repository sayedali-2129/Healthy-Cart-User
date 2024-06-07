
List<String> keywordsBuilder(String convertName) {
  final filteredKeyword = convertName.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  List<String> words = filteredKeyword.split(" ");
  List<String> substrings = [];
  for (String word in words) {
    String currentSubstring = "";
    for (int i = 0; i < word.length; i++) {
      currentSubstring += word[i];
      substrings.add(currentSubstring.toLowerCase());
    }
    substrings.add(word.toLowerCase());
  }
  if (!words.contains("")) {
    substrings.add(filteredKeyword.replaceAll(' ', '').toLowerCase());
  }
  substrings = substrings.toSet().toList();
  substrings.remove('');
  substrings.sort();

  return substrings;
}