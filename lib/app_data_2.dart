import 'package:flutter/material.dart';
import 'dart:math';

class AppData with ChangeNotifier {

  List<List<List<String>>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';
  int mineAmount = 0;

  void newBoard(int type){
    int dimensions;

    switch(type){
      case 1: dimensions = 9; break;
      case 2: dimensions = 15; break;
      default: dimensions = 9; break;
    }

    board = List.generate(dimensions, (i) => List.generate(dimensions, (j) => List.generate(2, (k) => "-")));
  }

  void setMines(int type){
    switch(type){
      case 1: mineAmount = 5; break;
      case 2: mineAmount = 10; break;
      case 3: mineAmount = 20; break;
      default: mineAmount = 5; break;
    }
  }

  void setCells(){
    while(mineAmount > 0) {
      for (var i = 0; i < board.length; i++) {
        for (var j = 0; i < board.length; j++) {
            if(Random().nextInt(100) > 80 && board[i][j][0]!="*"){
              board[i][j][0] = "*";
              mineAmount--;
            }
        }
      }
    }
  }

  void clearCell(int row, int column){
    if(board[column][row][0] != '*'){
      board[column][row][1] = 'C';
    } else {
      //TODO GameOver
    }
  }

  void markCell(int row, int column){
    board[column][row][1] = 'M';
  }

}
