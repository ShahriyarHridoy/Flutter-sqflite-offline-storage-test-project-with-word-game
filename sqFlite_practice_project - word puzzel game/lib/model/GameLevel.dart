class GameLevel {
  int? level;
  String? letters;
  late final String words;
  late final String array;

  gameLevelMap() {
    var mapping = Map<String, dynamic>();
    mapping['level'] = level ?? null;
    mapping['array'] = array;
    mapping['country'] = array;
    mapping['city'] = array;
    mapping['letters'] = letters!;
    mapping['words'] = words;
    
    return mapping;
  }
}
