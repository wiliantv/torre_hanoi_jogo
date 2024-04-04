import 'package:shared_preferences/shared_preferences.dart';

class GameController{
  static GameController? _instance;


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
  }


  set player(String value) {
    preferences.setString("lastPlayer", value);
  }

  String get player =>  preferences.getString("lastPlayer") ?? "";

  SharedPreferences get preferences => _preferences;

}