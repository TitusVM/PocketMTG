import 'package:flutter/material.dart';

class Player {
  final String name;
  int life;
  Color favColor;
  String favIcon;

  Player({
    required this.name,
    required this.life,
    required this.favColor,
    required this.favIcon,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] as String,
      life: map['life'] as int,
      favColor: Color(map['favColor']).withOpacity(1),
      favIcon: map['favIcon'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'life': life,
      'favColor': favColor.value,
      'favIcon': favIcon,
    };
  }
}