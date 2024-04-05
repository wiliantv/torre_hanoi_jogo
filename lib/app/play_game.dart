import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torre_hanoi/app/widgets/scores.dart';
import 'package:torre_hanoi/service/game_controller.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({Key? key}) : super(key: key);

  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    setState(() {
    _nameController.text = GameController.instance.player;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Torre de Hanói'),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              playerName(),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed('game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Icon(Icons.play_arrow, size: 36),
                label: Text(
                  'Jogar',
                  style: TextStyle(fontSize: 20, color: Colors.white), // Cor do texto do botão
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _clearData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Limpar Dados', style: TextStyle(fontSize: 12, color: Colors.white)), // Cor do texto do botão
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ScoresDialog(), // Exibir o diálogo de pontuações
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Scores', style: TextStyle(fontSize: 12, color: Colors.white)), // Cor do texto do botão
                  ),
                ]
              ),
            ],
          ),
        )
      ),
    );
  }

  Row playerName() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Jogador",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: _updatePlayerName,
                        icon: Icon(Icons.check),
                      ),
                    ),
                  ),
                ),
              ],
            );
  }

  void _updatePlayerName() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nome atualizado para ${_nameController.text}'),
        duration: Duration(seconds: 2),
      ),
    );
    GameController.instance.player = _nameController.text ;
  }

  void _clearData() {
    GameController.instance.preferences.clear();
    _nameController.clear();
    setState(() {
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dados limpos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
