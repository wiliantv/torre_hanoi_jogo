import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:torre_hanoi/service/score.dart';

class GameController{
  static GameController? _instance;
  static final int maxDisks = 15;
  static final minDisks = 2;

  late List<BestScore> _scores;
  static GameController get instance => _instance!;

  static Future<GameController> initialize() async {
    if(_instance == null) {
      var preferences = await SharedPreferences.getInstance();
      _instance = GameController._(preferences);
    }
    return _instance!;
  }


  late SharedPreferences _preferences;

  GameController._(SharedPreferences preferences){
    _preferences = preferences;
    _init();
  }

  _init(){
    _scores = _preferences.containsKey("bestScores") ? jsonDecode(_preferences.getString("bestScores")!).map((e) => scores.add(BestScore.fromMap(e))): [];
  }

  void reset(){
    preferences.clear();
    _init();
  }


  set player(String value) {
    preferences.setString("lastPlayer", value);
  }

  String get player =>  preferences.getString("lastPlayer") ?? "";

  SharedPreferences get preferences => _preferences;

  List<BestScore> get scores => _scores;
  List<BestScore> get scoresPlayer => _scores.where((element) => element.player == player).toList();

  void checkScore(int numberOfDisks, int movimentos, int time) {
    var list = scoresPlayer.where((element) => element.discos == numberOfDisks).toList();
    var score;

    if (list.isEmpty) {
      score = BestScore(numberOfDisks, time, player, movimentos);
      _scores.add(score);
    } else {
      list.sort((a, b) => a.time.compareTo(b.time));

      if (list.length > 1) {
        list.removeRange(1, list.length);
      }

      score = list.first;

      if (score.time > time) {
        _scores.remove(score);
        score = BestScore(numberOfDisks, time, player, movimentos);
        _scores.add(score);
      }
    }

    _preferences.setString("bestScores", jsonEncode(scores.map((e) => e.toMap()).toList()));
  }


}