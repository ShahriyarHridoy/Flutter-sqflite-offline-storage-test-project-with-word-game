import 'package:flutter/material.dart';
import 'package:sqflite_practice_project/model/GameLevel.dart';
import 'package:sqflite_practice_project/screens/EditGameLevel.dart';
import 'package:sqflite_practice_project/screens/addGameLevel.dart';
import 'package:sqflite_practice_project/screens/gridViewGameLevel.dart';
import 'package:sqflite_practice_project/screens/viewGameLevel.dart';
import 'package:sqflite_practice_project/services/gameLevelService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<GameLevel> _gameLevelList = <GameLevel>[];
  final _gameLevelService = GameLevelService();

  getAllGameLevelDetails() async {
    var gameLevels = await _gameLevelService.readAllGameLevels();
    _gameLevelList = <GameLevel>[];
    gameLevels.forEach((gameLevel) {
      setState(() {
        var gameLevelModel = GameLevel();
        gameLevelModel.level = gameLevel['level'];
        gameLevelModel.letters = gameLevel['letters'];
        gameLevelModel.words = gameLevel['words'];
        gameLevelModel.array = gameLevel['array'];
        _gameLevelList.add(gameLevelModel);
      });
    });
  }

  @override
  void initState() {
    getAllGameLevelDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, gameLevelId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    var result =
                        await _gameLevelService.deleteGameLevel(gameLevelId);
                    if (result != null) {
                      Navigator.pop(context);
                      getAllGameLevelDetails();
                      _showSuccessSnackBar('GameLevel Detail Deleted Success');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
      ),
      body: ListView.builder(
          itemCount: _gameLevelList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewGameLevel(
                                gameLevel: _gameLevelList[index],
                              )));
                },
                leading: const Icon(Icons.person),
                title: Text(_gameLevelList[index].letters ?? ''),
                subtitle: Text(_gameLevelList[index].words ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GridViewGameLevel(
                                        gameLevel: _gameLevelList[index],
                                      ))).then((data) {
                            if (data != null) {
                              getAllGameLevelDetails();
                              _showSuccessSnackBar(
                                  'GameLevel Detail Updated Success');
                            }
                          });
                          
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.teal,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditGameLevel(
                                        gameLevel: _gameLevelList[index],
                                      ))).then((data) {
                            if (data != null) {
                              getAllGameLevelDetails();
                              _showSuccessSnackBar(
                                  'GameLevel Detail Updated Success');
                            }
                          });
                          ;
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteFormDialog(
                              context, _gameLevelList[index].level);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddGameLevel()))
              .then((data) {
            if (data != null) {
              getAllGameLevelDetails();
              _showSuccessSnackBar('GameLevel Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
