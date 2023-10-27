import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';


class AppData with ChangeNotifier {
  // App status
  String winner = "Game over you lost!";

  int mineAmount = 0;
  int gridDimensions = 0;

  List<List<List<String>>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  void newBoard(int type){
    int dimensions;

    switch(type){
      case 0: dimensions = 9; break;
      case 1: dimensions = 15; break;
      default: dimensions = 9; break;
    }

    board = List.generate(dimensions, (i) => List.generate(dimensions, (j) => List.generate(2, (k) => "-")));
    gridDimensions = board.length;
  }

  int nearMines(int row, int col) {
    int mines = 0;

    List<List<int>> positions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], /*[0, 0],*/ [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];

    for (List<int> position in positions) {
      int newRow = row + position[0];
      int newCol = col + position[1];

      if (newRow >= 0 && newRow < gridDimensions && newCol >= 0 && newCol < gridDimensions) {
        if (board[newRow][newCol][0] == '*') {
          mines++;
        }
      }
    }

    return mines;
  }


  void setMines(int type){
    switch(type){
      case 0: mineAmount = 5; break;
      case 1: mineAmount = 10; break;
      case 2: mineAmount = 20; break;
      default: mineAmount = 5; break;
    }
  }

  bool checkBomb(int row, int col){
    if (board[row][col][0] == '*') {
      return true;
    }
    return false;
  }

  void isTheGameOver() {
    int markedMines = 0;

    for(int i = 0; i<gridDimensions;i++) {
      print(mineAmount);
      for(int j = 0; j<gridDimensions;j++) {
        if(board[i][j][0] == '*' && board[i][j][1] == 'C') {
          gameIsOver = true;
          return;
        } else if (board[i][j][0] == '*' && board[i][j][1] == 'M') {
          markedMines++;

          if(markedMines >= mineAmount) {
            winner = "Congratulations, you won!";
            gameIsOver = true;
          }
        }

      }
    }
  }

  void setCells(){
    int totalCells = gridDimensions * gridDimensions;
    int mines = 1;

    while(mines < mineAmount) {
      for (int i = 0; i < gridDimensions; i++) {
        for (int j = 0; j < gridDimensions; j++) {
          if(Random().nextInt(totalCells) < mineAmount && board[i][j][0]!="*"){
            board[i][j][0] = "*";
            mines++;
          }
        }
      }
    }
  }

  void revealCells(int row, int col) {
    if (row < 0 || row >= board.length || col < 0 || col >= board[0].length) {
      return;
    }

    if (board[row][col][0] == '*' || board[row][col][1] == 'C') {
      return;
    }

    board[row][col][1] = 'C';

    int nearbyMines = nearMines(row, col);
    if (nearbyMines > 0) {
      return;
    }

    revealCells(row - 1, col - 1);
    revealCells(row - 1, col);
    revealCells(row - 1, col + 1);
    revealCells(row, col - 1);
    revealCells(row, col + 1);
    revealCells(row + 1, col - 1);
    revealCells(row + 1, col);
    revealCells(row + 1, col + 1);
  }


  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    //Image tmpPlayer = Image.asset('assets/images/player.png');
    //Image tmpOpponent = Image.asset('assets/images/opponent.png');

    // Carrega les imatges


    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (info, _) => completer.complete(info.image),
      ),
    );
    return completer.future;
  }
}
