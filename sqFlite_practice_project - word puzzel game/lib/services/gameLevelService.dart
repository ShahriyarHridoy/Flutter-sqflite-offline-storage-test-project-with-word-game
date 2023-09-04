
import 'dart:async';

import 'package:sqflite_practice_project/model/GameLevel.dart';

import '../db_helper/repository.dart';




class GameLevelService
{
  late Repository _repository;
  GameLevelService(){
    _repository = Repository();
  }
  //Save GameLevel
  SaveGameLevel(GameLevel gameLevel) async{
    return await _repository.insertData('gameLevelData', gameLevel.gameLevelMap());
  }
  //Read All GameLevels
  readAllGameLevels() async{
    return await _repository.readData('gameLevelData');
  }
  //Edit GameLevel
  UpdateGameLevel(GameLevel gameLevel) async{
    return await _repository.updateData('gameLevelData', gameLevel.gameLevelMap());
  }

  deleteGameLevel(gameLevelId) async {
    return await _repository.deleteDataById('gameLevelData', gameLevelId);
  }

}