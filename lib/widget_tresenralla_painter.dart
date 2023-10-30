import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5;

    final int dimensions = appData.gridDimensions;

    double smallerDimension = size.width < size.height ? size.width : size.height;
    double cellDimension = smallerDimension / (dimensions);

    double offsetX = (size.width - (cellDimension * (dimensions))) / 2;
    double offsetY = (size.height - (cellDimension * dimensions)) / 2;

    // Dibuixem les linies verticals
    for(var i=0; i<dimensions + 1;i++){
      canvas.drawLine(
        Offset(offsetX + cellDimension * i, offsetY),
        Offset(offsetX + cellDimension * i, offsetY + cellDimension * dimensions),
        paint
      );
    }

    // dibuixem les linies horitzontals

    for(var i=0; i<dimensions + 1;i++){
      canvas.drawLine(
          Offset(offsetX, offsetY + cellDimension * i),
          Offset(offsetX + cellDimension * dimensions, offsetY + cellDimension * i),
          paint
      );
    }

  }

  void drawTimer(Canvas canvas){

  }

  void paintCell(Canvas canvas, double x0, double y0, int dimension, int row, int column, Size size){
    Rect cell = Rect.fromLTWH(x0, y0, dimension.toDouble(), dimension.toDouble());
    Paint paint;

    if (appData.checkBomb(row, column) && appData.board[row][column][1] == 'C') {
      paint = Paint()..color = Color.fromARGB(255, 255, 8, 7);
      canvas.drawRect(cell, paint);
      return;
    }

    switch(appData.board[row][column][1]) {
      case '-': paint = Paint()..color = Color.fromARGB(250, 150, 2, 90);
      case 'C': paint = Paint()..color = Color.fromARGB(255, 240, 247, 245);
      case 'M': paint = Paint()..color = Color.fromARGB(255, 255, 249, 59);
      default: paint = Paint()..color = Color.fromARGB(250, 150, 2, 90);
    }

    canvas.drawRect(cell, paint);

    if (appData.board[row][column][1] == 'C') {
      int nearMines = appData.nearMines(row, column);

      if (nearMines == 0) {return;}
      drawStringOnCanvas(canvas, appData.nearMines(row, column).toString(), x0, y0, paint, size);
    }
  }

  void drawStringOnCanvas(Canvas canvas, String string, double x, double y, Paint paint, Size size) {
    int dimensions = appData.gridDimensions;
    double smallerDimension = size.width < size.height ? size.width : size.height;
    double cellDimension = smallerDimension / (dimensions);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: string,
        style: TextStyle(
          color: Colors.black,
          fontSize: cellDimension * 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Calculate the x-coordinate to start drawing the number
    double xOffset = x + (cellDimension - textPainter.width) / 2;

    // Calculate the y-coordinate to start drawing the number,
    // considering the height of the text
    double yOffset = y + (cellDimension - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(xOffset, yOffset));
  }

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    final int dimensions = appData.gridDimensions;

    double smallerDimension = size.width < size.height ? size.width : size.height;
    double cellDimension = smallerDimension / (dimensions);

    double offsetX = (size.width - (cellDimension * (dimensions))) / 2;
    double offsetY = (size.height - (cellDimension * dimensions)) / 2;

    for (int i = 0; i < appData.board.length; i++) {
      for (int j = 0; j < appData.board[i].length; j++) {
        double x0 = j * cellDimension + offsetX; // Calculate x coordinate with offset
        double y0 = i * cellDimension + offsetY; // Calculate y coordinate with offset
        paintCell(canvas, x0, y0, cellDimension.toInt(), i, j, size);
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = appData.winner;

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardStatus(canvas, size);
    drawBoardLines(canvas, size);
    drawStringOnCanvas(canvas, "Mines: " + appData.markedMines.toString(), size.width / 10, size.height / 10, new Paint(), size);
    if (appData.gameIsOver) {
      drawGameOver(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
