import 'dart:async';

import 'package:torre_hanoi/service/tower.dart';

class TowerController {
  String player;
  late final List<Tower> towers;
  GameStates _state = GameStates();
  late StreamController<GameStates> _stateController;
  Stream<GameStates> get stateStream => _stateController.stream;
  int numberOfDisks;

  late StreamController<List<Tower>> _streamController;
  Stream<List<Tower>> get stream => _streamController.stream;


  Tower? get selectedTower => _state._selectedTower;

  TowerController({this.player = "Jogador", required this.numberOfDisks}) {
    towers = List.generate(3, (index) => Tower(index + 1));
    _streamController = StreamController<List<Tower>>.broadcast();
    _stateController = StreamController<GameStates>.broadcast();
  }


  void moverTorre(Tower origem, Tower destino) {
    if (_state._startTime == null) {
      _state._startTime = DateTime.now();
    }

    if (origem.disks.isEmpty || origem == destino) {
      return; // Disco já está na torre de destino
    }

    if (destino.disks.isEmpty ||
        destino.disks.last > origem.disks.last) {
      var lastDisk = origem.disks.last;
      origem.disks.remove(lastDisk);
      destino.disks.add(lastDisk);
      _state._movimentos++;
      _streamController!.sink.add(towers);
      print(
          "Voce moveu o disco ${lastDisk} da torre ${origem.index} para a torre ${destino.index}");
    }
    verificarVitoria();
    _stateController.add(_state);
  }

  bool verificarVitoria() {
    _state._vitoria = towers.last.disks.length == numberOfDisks;
    if(_state._vitoria){
      _state._endTime = DateTime.now();
    }
    return _state._vitoria;
  }

  void reset() {
    _state._selectedTower = null;
    _state._movimentos = 0;
    _streamController!.sink.add(towers);
    _state._startTime = null;
    _state._endTime = null;
    resetDiscos(numberOfDisks);
    print("Jogo Resetado");
  }

  void resetDiscos(int disks) {
    this.numberOfDisks = disks;
    for (var tower in towers) {
      tower.disks.clear();
    }

    for (int i = disks; i > 0; i--) {
      towers[0].disks.add(i);
    }
  }

  void move(Tower? selectedAux) {
    if (selectedAux != null) {
      if (_state._selectedTower == null) {
        _state._selectedTower = selectedAux;
      } else {
        moverTorre(_state._selectedTower!, selectedAux);
        _state._selectedTower = null;
      }
      _streamController!.sink.add(towers);
    }
  }

  Duration getElapsedTime() {
    if (_state._startTime == null) {
      return Duration.zero;
    }
    if(_state._endTime != null){
      return _state._endTime!.difference(_state._startTime!);
    }
    return DateTime.now().difference(_state._startTime!);
  }

  Stream<int> get elapsedTimeStream async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield getElapsedTime().inSeconds;
    }
  }
}



class GameStates {
  int _movimentos = 0;
  int get movimentos => _movimentos;
  DateTime? _startTime;
  DateTime? _endTime;
  Tower? _selectedTower;
  bool _vitoria = false;
}
