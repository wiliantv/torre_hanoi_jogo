class BestScore{
  int discos;
  int time;
  int movimentos;
  String player;

  BestScore(this.discos, this.time, this.player, this.movimentos);

  Map<String, dynamic> toMap(){
    return {
      'discos': discos,
      'time': time,
      'player': player,
      'movimentos': movimentos
    };
  }

  static BestScore fromMap(Map<String, dynamic> map){
    return BestScore(map['discos'], map['time'], map['player'], map['movimentos']);
  }
}