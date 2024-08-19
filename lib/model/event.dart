import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final DateTime startAt;

  @HiveField(5)
  final int duration;

  @HiveField(6)
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startAt,
    required this.duration,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      duration: json['duration'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String getFormattedDate() {
    return DateFormat('EEE dd MMM').format(startAt).toUpperCase();
  }
}
