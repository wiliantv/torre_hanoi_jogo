import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torre_hanoi/app/HanoiTower.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hanoi Towers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HanoiTower20(),
    );
  }
}
//
// class Tower {
//   int index;
//   List<Disk> _disks = [];
//   StreamController<List<Disk>> _towersStreamController =
//       StreamController.broadcast();
//
//   addDisk(Disk disk) {
//     _disks.add(disk);
//     _towersStreamController.sink.add(_disks);
//   }
//
//   get disks => _disks;
//
//   removeDisk(Disk disk) {
//     _disks.remove(disk);
//     _towersStreamController.sink.add(_disks);
//   }
//
//   get stream => _towersStreamController.stream;
//
//   Tower(this.index);
// }
//
// class TowerController {
//   static TowerController instance = new TowerController._();
//   late List<Tower> towers;
//   int disks = 7;
//   StreamController<int> _streamControllerMovimento =
//       StreamController.broadcast();
//   int movimento = 0;
//   Tower? _selectedTower;
//   DateTime? _startTime;
//
//   isSelected(Tower tower) {
//     return _selectedTower == tower;
//   }
//
//   TowerController._() {
//     towers = [
//       Tower(1),
//       Tower(2),
//       Tower(3),
//     ];
//     resetDiscos(disks);
//     movimento = 0;
//     instance = this;
//   }
//
//   void moverTorre(Tower origem, Tower destino) {
//     if (_startTime == null) {
//       _startTime = DateTime.now();
//     }
//
//     if (origem.disks.isEmpty || origem == destino) {
//       return; // Disco já está na torre de destino
//     }
//
//     if (destino.disks.isEmpty ||
//         destino.disks.last.number > origem.disks.last.number) {
//       var lastDisk = origem.disks.last;
//       origem.removeDisk(lastDisk);
//       destino.addDisk(lastDisk);
//       movimento++;
//       _streamControllerMovimento.sink.add(movimento);
//       print(
//           "Voce moveu o disco ${lastDisk.number} da torre ${origem.index} para a torre ${destino.index}");
//     }
//
//     if (verificarVitoria()) {
//       print('Parabéns! Você venceu o jogo!');
//     }
//   }
//
//   bool verificarVitoria() {
//     return towers.last.disks.length == disks;
//   }
//
//   void reset() {
//     _selectedTower = null;
//     movimento = 0;
//     _streamControllerMovimento.sink.add(movimento);
//     resetDiscos(disks);
//     _startTime = null;
//   }
//
//   void resetDiscos(int disks) {
//     this.disks = disks;
//     for (var tower in towers) {
//       tower.disks.clear();
//     }
//
//     for (int i = disks; i > 0; i--) {
//       towers[0].addDisk(Disk(i));
//     }
//   }
//
//   void move(Tower? selectedAux) {
//     if (selectedAux != null) {
//       if (_selectedTower == null) {
//         _selectedTower = selectedAux;
//       } else {
//         moverTorre(_selectedTower!, selectedAux);
//         _selectedTower = null;
//       }
//     }
//   }
//
//   Duration _getElapsedTime() {
//     if (_startTime == null) {
//       return Duration.zero;
//     }
//     return DateTime.now().difference(_startTime!);
//   }
//
//   Stream<int> get elapsedTimeStream async* {
//     while (true) {
//       await Future.delayed(Duration(seconds: 1));
//       yield _getElapsedTime().inSeconds;
//     }
//   }
// }
//
// class TowerWidget extends StatelessWidget {
//   final Tower torre;
//
//   TowerWidget(this.torre);
//
//   @override
//   Widget build(BuildContext context) {
//     final isSelected = TowerController.instance.isSelected(torre);
//     final borderColor = isSelected ? Colors.blue : Colors.black;
//
//     return GestureDetector(
//       onTap: () => TowerController.instance.move(torre),
//       child: Column(
//         children: [
//           Text(
//             'Torre ${torre.index}',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           StreamBuilder<List<Disk>>(
//             stream: torre.stream,
//             builder: (context, snapshot) {
//               return Container(
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: borderColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: !snapshot.hasData
//                     ? Container()
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: snapshot.data!
//                             .map((disk) =>
//                                 DiskWidget(disk: disk, towerWidth: 100))
//                             .toList()
//                             .reversed
//                             .toList(),
//                       ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DiskWidget extends StatelessWidget {
//   final Disk disk;
//   final double towerWidth;
//
//   const DiskWidget({Key? key, required this.disk, required this.towerWidth})
//       : super(key: key);
//
//   Color generateColorFromNumber(int number) {
//     // Calcular os componentes de cor usando operações matemáticas
//     int alpha = 255; // 255 é o valor máximo para opacidade (totalmente opaco)
//     int red = (number * 17) % 256; // Uma maneira de obter um valor de 0 a 255
//     int green =
//         (number * 31) % 256; // Outra maneira de obter um valor de 0 a 255
//     int blue =
//         (number * 47) % 256; // Outra maneira de obter um valor de 0 a 255
//
//     // Retornar a cor criada com os componentes calculados
//     return Color.fromARGB(alpha, red, green, blue);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final diskWidth = (disk.number * 100 / (TowerController.instance.disks)) *
//         100 /
//         towerWidth; // Ajustando a largura do disco
//     final diskHeight = 20.0;
//     final borderRadius = BorderRadius.circular(5.0);
//     final shadowColor = Colors.black.withOpacity(0.4);
//
//     return Container(
//       width: diskWidth,
//       height: diskHeight,
//       decoration: BoxDecoration(
//         color: generateColorFromNumber(disk.number),
//         borderRadius: borderRadius,
//         boxShadow: [
//           BoxShadow(
//             color: shadowColor,
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: Offset(0, 1), // changes position of shadow
//           ),
//         ],
//       ),
//       margin: EdgeInsets.symmetric(vertical: 2),
//       child: Center(
//         child: Text(
//           '${disk.number}',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//
// class Disk {
//   final int _number;
//
//   int get number => _number;
//
//   Disk(this._number);
// }
//
// class HanoiTower extends StatefulWidget {
//   @override
//   _HanoiTowerState createState() => _HanoiTowerState();
// }
//
// class _HanoiTowerState extends State<HanoiTower> {
//   late TowerController _towerController = TowerController.instance;
//
//   var focusNode = new FocusNode();
//   int _numDiscos = 7;
//
//   @override
//   void initState() {
//     super.initState();
//     focusNode.requestFocus();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Torres de Hanói'),
//       ),
//       body: KeyboardListener(
//         focusNode: focusNode,
//         autofocus: true,
//         onKeyEvent: (event) {
//           if (event is KeyDownEvent) {
//             _handleKeyPress(event.logicalKey);
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StreamBuilder<int>(
//                 stream: _towerController._streamControllerMovimento.stream,
//                 builder: (context, snapshot) {
//                   return Text(
//                     'Movimentos: ${snapshot.data ?? 0}',
//                     style: TextStyle(fontSize: 20),
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//               StreamBuilder<int>(
//                 stream: _towerController.elapsedTimeStream,
//                 builder: (context, snapshot) {
//                   return Text(
//                     'Tempo decorrido: ${_formatDuration(snapshot.data ?? 0)}',
//                     style: TextStyle(fontSize: 20),
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children:
//                     _towerController.towers.map((e) => TowerWidget(e)).toList(),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Número de Discos: '),
//                   SizedBox(width: 10),
//                   DropdownButton<int>(
//                     value: _numDiscos,
//                     items: List.generate(10, (index) => index + 1)
//                         .map((int value) {
//                       return DropdownMenuItem<int>(
//                         value: value,
//                         child: Text(value.toString()),
//                       );
//                     }).toList(),
//                     onChanged: (int? newValue) {
//                       setState(() {
//                         _numDiscos = newValue!;
//                         _towerController.resetDiscos(_numDiscos);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _towerController.reset();
//                     focusNode.requestFocus();
//                   });
//                 },
//                 child: Text('Resetar'),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Movimentos mínimos: ${pow(2, _numDiscos) - 1}',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDuration(int seconds) {
//     Duration duration = Duration(seconds: seconds);
//     return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
//   }
//
//   void _handleKeyPress(LogicalKeyboardKey key) {
//     Tower? selectedAux;
//     if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
//       selectedAux = _towerController.towers[0];
//     } else if (key == LogicalKeyboardKey.digit2 ||
//         key == LogicalKeyboardKey.numpad2) {
//       selectedAux = _towerController.towers[1];
//     } else if (key == LogicalKeyboardKey.digit3 ||
//         key == LogicalKeyboardKey.numpad3) {
//       selectedAux = _towerController.towers[2];
//     }
//     _towerController.move(selectedAux);
//   }
// }
