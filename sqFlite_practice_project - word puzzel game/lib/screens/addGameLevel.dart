
import 'package:flutter/material.dart';
import 'package:sqflite_practice_project/model/GameLevel.dart';
import '../services/gameLevelService.dart';

class AddGameLevel extends StatefulWidget {
  const AddGameLevel({Key? key}) : super(key: key);

  @override
  State<AddGameLevel> createState() => _AddGameLevelState();
}

class _AddGameLevelState extends State<AddGameLevel> {
  var _gameLevelLettersController = TextEditingController();
  var _gameLevelWordsController = TextEditingController();
  var _gameLevelArrayController = TextEditingController();
  bool _validateLetters = false;
  bool _validateWords = false;
  bool _validateArray = false;
  var _gameLevelService=GameLevelService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New GameLevel',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _gameLevelLettersController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Letters',
                    labelText: 'Letters',
                    errorText:
                        _validateLetters ? 'Letters Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _gameLevelWordsController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Words',
                    labelText: 'Words',
                    errorText: _validateWords
                        ? 'Words Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _gameLevelArrayController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Array',
                    labelText: 'Array',
                    errorText: _validateArray
                        ? 'Array Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _gameLevelLettersController.text.isEmpty
                              ? _validateLetters = true
                              : _validateLetters = false;
                          _gameLevelWordsController.text.isEmpty
                              ? _validateWords = true
                              : _validateWords = false;
                          _gameLevelArrayController.text.isEmpty
                              ? _validateArray = true
                              : _validateArray = false;

                        });
                        if (_validateLetters == false &&
                            _validateWords == false &&
                            _validateArray == false) {
                         // print("Good Data Can Save");
                          var _gameLevel = GameLevel();
                          _gameLevel.letters = _gameLevelLettersController.text;
                          _gameLevel.words = _gameLevelWordsController.text;
                          _gameLevel.array = _gameLevelArrayController.text;
                          var result=await _gameLevelService.SaveGameLevel(_gameLevel);
                         Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Save Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _gameLevelLettersController.text = '';
                        _gameLevelWordsController.text = '';
                        _gameLevelArrayController.text = '';
                      },
                      child: const Text('Clear Details'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
