import 'package:flutter/material.dart';

class Player {
  final String name;
  int life;
  int poison;
  int cmdtDamage;
  Color favColor;
  String favIcon;

  Player({
    required this.name,
    required this.life,
    required this.poison,
    required this.cmdtDamage,
    required this.favColor,
    required this.favIcon,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] as String,
      life: map['life'] as int,
      poison: map['poison'] as int,
      cmdtDamage: map['cmdtDamage'] as int,
      favColor: Color(map['favColor']).withOpacity(1),
      favIcon: map['favIcon'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'life': life,
      'poison': poison,
      'cmdtDamage': cmdtDamage,
      'favColor': favColor.value,
      'favIcon': favIcon,
    };
  }
}
