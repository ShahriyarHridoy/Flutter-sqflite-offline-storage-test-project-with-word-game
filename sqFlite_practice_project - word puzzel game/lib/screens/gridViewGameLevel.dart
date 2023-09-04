import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite_practice_project/model/GameLevel.dart';
import 'package:sqflite_practice_project/screens/input_clock.dart';

class GridViewGameLevel extends StatefulWidget {
  final GameLevel gameLevel;

  const GridViewGameLevel({Key? key, required this.gameLevel})
      : super(key: key);

  @override
  State<GridViewGameLevel> createState() =>
      _GridViewGameLevelState(gameLevel.array as String, gameLevel.words);
}

bool visibleWords = true;
String puzzelWord = '';

class _GridViewGameLevelState extends State<GridViewGameLevel> {
  final String arraydata;
  String? wordString;

  _GridViewGameLevelState(this.arraydata, this.wordString);

  GlobalKey<_GridViewGameLevelState> _gridViewGameLevelKey = GlobalKey();

  List<List<String>> grid = [];
  late List<String> wordsToFind =
      wordString!.replaceAll(' ', '').trim().split(',');
  // List<String> wordsToFind1 = ['NOW', 'WON', 'OWN'];
  List<List<bool>> wordFound = [];
  // List<List<String>> grid1 = [
  //   ['', '', '', '', '', '', ''],
  //   ['', 'W', 'O', 'N', '', '', ''],
  //   ['', '', '', 'O', '', '', ''],
  //   ['', '', 'O', 'W', 'N', '', ''],
  //   ['', '', '', '', '', '', ''],
  // ];
  List<List<bool>> wordFound1 =
      List.generate(5, (i) => List.generate(7, (j) => false));

  bool boxColor = false;

  List<List<String>> chunk(List<String> array, int size) {
    List<List<String>> chunks = [];
    int i = 1;
    while (i < array.length) {
      int j = i + size;
      chunks.add(array.sublist(i, j > array.length ? array.length : j));
      i = j;
    }
    return chunks;
  }

  void parseDataString(String data) {
    // Remove unnecessary characters and split into rows
    data = data.replaceAll(' ', '').trim();

    List<String> rows = data
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('],[', '')
        .replaceAll(',,', ',')
        .replaceAll("''", "")
        .replaceAll("'", "")
        .replaceAll('""', '')
        .replaceAll('"', '')
        .trim()
        .split(',');
    // rows.removeWhere((element) => element.isEmpty);
    // .replaceAll("''", " ")
    //     .replaceAll("'", "")

    print(rows);
    print("###############");
    // print(rows.length);
    // print(('['.allMatches(data).length - 1));

    int num = ((rows.length) / ('['.allMatches(data).length - 1)).toInt();
    grid = chunk(rows, num);

    // wordFound = List.generate(
    //      grid.length, (i) => List.generate(grid[0].length, (j) => false));

    return;
  }

  @override
  void initState() {
    super.initState();
    parseDataString(arraydata);
    wordFound = List.generate(
         grid.length, (i) => List.generate(grid[0].length, (j) => false));
    
  }

  // void test() {
  //   if (grid.length != grid1.length) {
  //     print("grid length ${grid.length}");
  //     print("grid1 length ${grid1.length}");

  //     print("length not matched");

  //     print("grid1:::::::::::::::::::::::::::::::::::::::");
  //     // log(json.encode(grid1));
  //     print(grid1);

  //     print("grid:::::::::::::::::::::::::::::::::::::::");
  //     print(grid);
  //     // log(json.encode(grid));
  //   } else {
  //     print("length matched");
  //   }
  //   for (int i = 0; i < grid.length; i++) {
  //     for (int j = 0; j < grid[i].length; j++) {
  //       if (grid1[i] == grid1[i]) {
  //         print(true);
  //         print("#" + grid1[i][j] + "#" + "=>" + "#" + grid[i][j] + "#");
  //         print(i);
  //         print(j);
  //         // val = true;
  //       } else {
  //         print("#" + grid1[i][j] + "#" + "=>" + "#" + grid[i][j] + "#");
  //         // val = false;
  //         print(false);
  //         print(i);
  //         print(j);
  //       }
  //     }
  //   }

  //   // bool val;
  //   // for (int i = 0; i < wordsToFind1.length; i++) {
  //   //   if (wordsToFind[i] == wordsToFind1[i]) {
  //   //     print(true);
  //   //     print(i);
  //   //     // val = true;
  //   //   } else {
  //   //     print("#"+wordsToFind[i] + "#"+ "=>" + "#"+ wordsToFind1[i]+ "#");
  //   //     // val = false;
  //   //     print(false);
  //   //     print(i);
  //   //   }
  //   // }
  // }

  void checkWord(String word) {
    print("%%%%%%%%%%%%%%%%%%%");
    print(word);
    if (wordsToFind.contains(word)) {
      setState(() {
        for (int row = 0; row < grid.length; row++) {
          for (int col = 0; col < grid[row].length; col++) {
            String currentWord = '';
            // Check horizontally
            for (int c = col; c < grid[row].length; c++) {
              if (grid[row][c].isEmpty) {
                break;
              }
              currentWord += grid[row][c];
              if (currentWord == word) {
                for (int i = 0; i < currentWord.length; i++) {
                  wordFound[row][col + i] = true;
                }
                break;
              }
            }
            // Check vertically
            currentWord = '';
            for (int r = row; r < grid.length; r++) {
              if (grid[r][col].isEmpty) {
                break;
              }
              currentWord += grid[r][col];
              if (currentWord == word) {
                for (int i = 0; i < currentWord.length; i++) {
                  wordFound[row + i][col] = true;
                }
                break;
              }
            }
          }
        }
      });
    }
  }

  bool areBoolListsEqual(List<List<bool>> list1, List<List<bool>> list2) {
  if (list1.length != list2.length) {
    return false;
  }
  
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].length != list2[i].length) {
      return false;
    }
    
    for (int j = 0; j < list1[i].length; j++) {
      if (list1[i][j] != list2[i][j]) {
        return false;
      }
    }
  }
  
  return true;
}

  @override
  Widget build(BuildContext context) {
    
    // print(wordsToFind);
    // parseDataString(arraydata);
    print("#############");
    print("#############");
    print(areBoolListsEqual(wordFound, wordFound1));
    // test();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword Puzzle'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[300],

              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: grid[0].length),
                itemBuilder: (context, index) {
                  int row = index ~/ grid[0].length;
                  int col = index % grid[0].length;
                  final cellValue = grid[row][col];

                  wordFound[row][col] ? boxColor = true : boxColor = false;
                  return CrosswordBox(cellValue, boxColor);
                },
                itemCount: 35,
              ),
              // child: Column(
              //   children: List.generate(grid.length, (rowIndex) {
              //     return Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: List.generate(grid[rowIndex].length, (colIndex) {
              //         final cellValue = grid[rowIndex][colIndex];

              //         wordFound[rowIndex][colIndex]
              //             ? boxColor = true
              //             : boxColor = false;
              //         return CrosswordCell(
              //             value: cellValue, colorBool: boxColor);
              //       }),
              //     );
              //   }),
              // ),
            ),

            SizedBox(
              height: 50,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       visibleWords = !visibleWords;
            //     });
            //     // Handle submit or check button click.
            //     // Implement logic to validate the crossword and check answers.
            //   },
            //   child: const Text('Submit'),
            // ),
            ClockInputPart(miniCircleCount: 3, callBackFunction: checkWord),
          ],
        ),
      ),
    );
  }
}

Widget CrosswordBox(String value, bool colorBool) {
  bool isLetter = value.isNotEmpty && value != " ";
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color:
              isLetter ? Colors.blueGrey.withOpacity(.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Text(
        // value,
        isLetter ? value.replaceAll("'", "") : ' ',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: value.isNotEmpty && value != "''" && value != "'"
                ? colorBool
                    ? Colors.black
                    : Colors.transparent
                : Colors.transparent),
      ),
    ),
  );
}

// class CrosswordCell extends StatelessWidget {
//   final String value;
//   final bool colorBool;
//   const CrosswordCell({required this.value, Key? key, required this.colorBool})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print(colorBool);
//     print("######################");
//     bool isLetter = value.isNotEmpty && value != " ";
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.transparent),
//             color:
//                 isLetter ? Colors.blueGrey.withOpacity(.5) : Colors.transparent,
//             borderRadius: BorderRadius.circular(5)),
//         alignment: Alignment.center,
//         child: Text(
//           // value,
//           isLetter ? value.replaceAll("'", "") : ' ',
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: value.isNotEmpty &&
//                       value != "''" &&
//                       value != "'" &&
//                       visibleWords == true
//                   ? colorBool
//                       ? Colors.black
//                       : Colors.blueGrey.withOpacity(.5)
//                   : Colors.transparent),
//         ),
//       ),
//     );
//   }
// }
