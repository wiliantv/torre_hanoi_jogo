import 'package:shared_preferences/shared_preferences.dart';

class GameController{
  static late GameController instance;

  // String player;
  late SharedPreferences _preferences;
  late String _player;

  GameController(SharedPreferences preferences){
    _preferences = preferences;
    instance = this;
  }

  SharedPreferences get preferences => _preferences;

  String get player{
    _player = _preferences.getString("player") ?? "Jogador";
    return _player;
  }

  set player(String player){
    _preferences.setString("player", player);
    _player = player;
  }


}