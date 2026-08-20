class Note {
  DateTime date;
  String title;
  String desc;
  bool isCompleted;
  String category;

  Note({
    required this.date,
    required this.title,
    required this.desc,
    required this.isCompleted,
    this.category = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(), 
      'title': title,
      'desc': desc,
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      date: DateTime.parse(map['date']), 
      title: map['title'],
      desc: map['desc'],
      isCompleted: map['isCompleted'],
      category: map['category'] ?? '',
    );
  }
}