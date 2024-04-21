class Player {
  final String name;
  int life;

  Player({
    required this.name,
    required this.life,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] as String,
      life: map['life'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'life': life,
    };
  }
}