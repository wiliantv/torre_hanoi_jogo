import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torre_hanoi/app/widgets/TowerWidget.dart';
import 'package:torre_hanoi/service/Tower.dart';
import 'package:torre_hanoi/service/TowerController.dart';

class HanoiTower20 extends StatefulWidget {
  @override
  _HanoiTowerState createState() => _HanoiTowerState();
}

class _HanoiTowerState extends State<HanoiTower20> {
  late TowerController _towerController;
  GameStates gameStates = GameStates();

  var focusNode = new FocusNode();
  int _numDiscos = 7;

  @override
  void initState() {
    _towerController = TowerController(numberOfDisks: _numDiscos);
    super.initState();
    focusNode.requestFocus();
    _towerController.reset();
    _towerController.stateStream.listen((state) {
      setState(() {
        gameStates = state;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Torres de Hanói'),
      ),
      body: KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            _handleKeyPress(event.logicalKey);
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Movimentos: ${gameStates.movimentos}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<int>(
                    stream: _towerController.elapsedTimeStream,
                    builder: (context, snapshot) {
                      return Text(
                        'Tempo decorrido: ${_formatDuration(snapshot.data ?? 0)}',
                        style: TextStyle(fontSize: 10),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<List<Tower>>(
                    stream: _towerController.stream,
                    initialData: _towerController.towers,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Tower> towers = snapshot.data!;
                        List<Widget> towerWidgets = towers.map((tower) {
                          return TowerWidget(
                            torre: tower,
                            onTap: _towerController.move,
                            isSelected: _towerController.selectedTower == tower,
                            numberOfDisks: _towerController.numberOfDisks,
                          );
                        }).toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: towerWidgets,
                        );
                      } else {
                        return Container(); // Se não houver dados, retorne um widget vazio
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Número de Discos: '),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _numDiscos,
                        items: List.generate(13, (index) => index + 3)
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _numDiscos = newValue!;
                            _towerController.resetDiscos(_numDiscos);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _towerController.reset();
                        focusNode.requestFocus();
                      });
                    },
                    child: Text('Resetar'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Movimentos mínimos: ${pow(2, _towerController.numberOfDisks) - 1}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            if (_towerController.verificarVitoria())
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.7),
                padding: EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        'VITÓRIA',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tempo decorrido: ${_formatDuration(_towerController.getElapsedTime().inSeconds)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Movimentos: ${gameStates.movimentos}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _towerController.reset();
                            focusNode.requestFocus();
                          });
                        },
                        child: Text('Jogar Novamente'),
                      ),
                    ],
                  ),
                ),
              ),
          ]
        )
      ),
    );
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void _handleKeyPress(LogicalKeyboardKey key) {
    Tower? selectedAux;
    if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
      selectedAux = _towerController.towers[0];
    } else if (key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.numpad2) {
      selectedAux = _towerController.towers[1];
    } else if (key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.numpad3) {
      selectedAux = _towerController.towers[2];
    }
    _towerController.move(selectedAux);
  }
}
