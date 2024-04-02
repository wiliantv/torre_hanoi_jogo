import 'package:flutter/material.dart';
import 'package:torre_hanoi/app/widgets/DiskWidget.dart';
import 'package:torre_hanoi/service/Tower.dart';

class TowerWidget extends StatelessWidget {
  final Tower torre;
  final bool isSelected;
  final Function(Tower) onTap;
  final int numberOfDisks;

  TowerWidget({
    required this.torre,
    required this.onTap,
    required this.isSelected,
    required this.numberOfDisks,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.blue : Colors.black;

    return GestureDetector(
      onTap: () => onTap.call(torre),
      child: Column(
        children: [
          Text(
            'Torre ${torre.index}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: torre.disks
                  .map((disk) => DiskWidget(
                      disk: disk,
                      towerWidth: 100,
                      numberOfDisks: numberOfDisks,
                      towerHeight: MediaQuery.of(context).size.height * 0.4))
                  .toList().reversed.toList()
                  // .reversed
                  // .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
