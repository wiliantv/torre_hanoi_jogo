import 'dart:math';

import 'package:flutter/material.dart';
import 'package:torre_hanoi/service/game_controller.dart';

import 'package:flutter/material.dart';
import 'package:torre_hanoi/service/game_controller.dart';
import 'package:torre_hanoi/service/score.dart';

class ScoresDialog extends StatefulWidget {
  @override
  _ScoresDialogState createState() => _ScoresDialogState();
}

class _ScoresDialogState extends State<ScoresDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Seus scores'),
                Tab(text: 'Todos por discos'),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BestScoresTab(),
                  PlayerScoresByDiscsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerScoresByDiscsTab extends StatefulWidget {
  @override
  _PlayerScoresByDiscsTabState createState() => _PlayerScoresByDiscsTabState();
}

class _PlayerScoresByDiscsTabState extends State<PlayerScoresByDiscsTab> {
  int? selectedDiscs; // Valor padrão para o filtro

  @override
  Widget build(BuildContext context) {
    var filteredScores = selectedDiscs == null ? []:GameController.instance.scores
        .where((element) => element.discos == selectedDiscs)
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Discos: '),
            DropdownButton<int>(
              value: selectedDiscs,
              onChanged: (value) {
                setState(() {
                  selectedDiscs = value!;
                });
              },
              items: List.generate(GameController.maxDisks-1, (index) => index + GameController.minDisks)
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value discos'),
                );
              }).toList(),
            )
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
        ),
        Row(children: [
          Expanded(
            child: SingleChildScrollView(
              child: filteredScores.isNotEmpty
                  ? DataTable(
                      columns: [
                        DataColumn(label: Text('Jogador')),
                        DataColumn(label: Text('Tempo')),
                        DataColumn(label: Text('Movimentos')),
                      ],
                      rows: filteredScores.map((score) {
                        return DataRow(cells: [
                          DataCell(Text(score.player)),
                          DataCell(Text(_formatDuration(score.time))),
                          DataCell(Text(
                              "${score.movimentos}/${pow(2, score.discos)}")),
                        ]);
                      }).toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Nenhum dado disponível'),
                    ),
            ),
          )
        ]),
      ],
    );
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

class BestScoresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BestScoresTable(),
    );
  }
}

class BestScoresTable extends StatefulWidget {
  @override
  _BestScoresTableState createState() => _BestScoresTableState();
}

class _BestScoresTableState extends State<BestScoresTable> {
  late List<BestScore> scores;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    scores = GameController.instance.scoresPlayer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Nenhum dado disponível'),
      );
    return DataTable(
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columns: [
        DataColumn(label: Text('Discos'), onSort: _sort),
        DataColumn(label: Text('Tempo'), onSort: _sort),
        DataColumn(label: Text('Movimentos'), onSort: _sort),
      ],
      rows: scores.map((score) {
        return DataRow(cells: [
          DataCell(Text(score.discos.toString())),
          DataCell(Text(_formatDuration(score.time))),
          DataCell(Text("${score.movimentos}/${pow(2, score.discos)}")),
        ]);
      }).toList(),
    );
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      scores.sort((a, b) {
        switch (columnIndex) {
          case 0:
            return a.discos.compareTo(b.discos);
          case 1:
            return a.time.compareTo(b.time);
          case 2:
            return a.movimentos.compareTo(b.movimentos);
          default:
            return 0;
        }
      });

      if (!_sortAscending) {
        scores = scores.toList();
      }
    });
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
