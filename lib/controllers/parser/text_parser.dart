class Chapters {
  String text;
  int start;

  Chapters({
    required this.start,
    required this.text,
  });

  @override
  String toString() {
    return "Chapter(text: $text, start: $start)";
  }

  static List<Chapters> parser(String text) {
    List<Chapters> chapters = [];
    List<String> lines = text.split('[');
    for (int i = 1; i < lines.length; i++) {
      List<String> filteredItems = [];
      List<String> items = lines[i].split(']');
      for (var kItem in items) {
        if (kItem != "" || kItem != ",") {
          filteredItems.add(kItem.trim());
        }
      }
      List<String> times = filteredItems.first.split(":");
      int hour = int.parse(times[0]);
      int min = int.parse(times[1]);
      int second = int.parse(times[2]);
      String text = filteredItems.last;

      int startTime = hour * 3600 + min * 60 + second;

      chapters.add(Chapters(start: startTime, text: text));
    }
    return chapters;
  }
}
