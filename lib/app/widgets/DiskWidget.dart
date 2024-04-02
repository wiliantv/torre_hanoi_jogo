import 'package:flutter/material.dart';

class DiskWidget extends StatelessWidget {
  final int disk;
  final int numberOfDisks;
  double towerWidth;
  double towerHeight;

  DiskWidget(
      {required this.disk,
      required this.numberOfDisks,
      required this.towerWidth,
      required this.towerHeight});

  Color generateColorFromNumber(int number) {
    // Calcular os componentes de cor usando operações matemáticas
    int alpha = 255; // 255 é o valor máximo para opacidade (totalmente opaco)
    int red = (number * 17) % 256; // Uma maneira de obter um valor de 0 a 255
    int green =
        (number * 31) % 256; // Outra maneira de obter um valor de 0 a 255
    int blue =
        (number * 47) % 256; // Outra maneira de obter um valor de 0 a 255

    // Retornar a cor criada com os componentes calculados
    return Color.fromARGB(alpha, number % 2 == 0 ? red : blue, green, number % 2 == 0 ? blue : red);
  }

  @override
  Widget build(BuildContext context) {
    final diskWidth = (disk * 100 / numberOfDisks) * 100 / towerWidth;
    final diskHeight = (towerHeight* 0.9)/numberOfDisks; // Ajustando a largura do disco
    final borderRadius = BorderRadius.circular(5.0);
    final shadowColor = Colors.black.withOpacity(0.4);

    return Container(
      width: diskWidth,
      height: diskHeight,
      decoration: BoxDecoration(
        color: generateColorFromNumber(disk),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Center(
        child: Text(
          String.fromCharCode('A'.codeUnitAt(0) + disk - 1),
          style: TextStyle(
              color: Colors.white, fontSize: 70/ (numberOfDisks)),
        ),
      ),
    );
  }
}
