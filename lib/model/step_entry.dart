class StepEntryModel {
  final int? id;
  final String date; //format :yyyy-MM-dd
  final int steps;

  StepEntryModel({this.id, required this.date, required this.steps});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'steps': steps,
    };
  }

  factory StepEntryModel.fromMap(Map<String, dynamic> map) {
    return StepEntryModel(id: map['id'], date: map['date'], steps: map['steps']);
  }
  
}
