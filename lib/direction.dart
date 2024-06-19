// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NavigationSteps {
  final String direction;
  NavigationSteps({
    required this.direction,
  });

  NavigationSteps copyWith({
    String? direction,
  }) {
    return NavigationSteps(
      direction: direction ?? this.direction,
    );
  }

  String message() {
    if (direction == 'left') {
      return 'Turn left 👈';
    } else if (direction == 'right') {
      return 'Turn right 👉';
    } else if (direction == 'forward') {
      return 'Go straight 🚶‍♂️';
    } else if (direction == 'backward') {
      return 'Go back 🔄';
    } else if (direction == 'no') {
      return "Don't move 🤚";
    } else {
      return direction;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'direction': direction,
    };
  }

  factory NavigationSteps.fromMap(Map<String, dynamic> map) {
    return NavigationSteps(
      direction: map['direction'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NavigationSteps.fromJson(String source) =>
      NavigationSteps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => direction;

  @override
  bool operator ==(covariant NavigationSteps other) {
    if (identical(this, other)) return true;

    return other.direction == direction;
  }

  @override
  int get hashCode => direction.hashCode;
}
