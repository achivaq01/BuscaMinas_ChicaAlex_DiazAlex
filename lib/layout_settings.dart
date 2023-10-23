import 'package:flutter/cupertino.dart';

class LayoutSettings extends StatefulWidget {
  @override
  _LayoutSettingsState createState() => _LayoutSettingsState();
}

class _LayoutSettingsState extends State<LayoutSettings> {
  int _selectedBoardSize = 0;
  int _selectedMineCount = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Configuración"),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text("Tamaño del Tablero:"),
            const SizedBox(height: 10),
            CupertinoSegmentedControl<int>(
              groupValue: _selectedBoardSize,
              children: const {
                0: Text("Pequeño"),
                1: Text("Grande"),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedBoardSize = value;
                });
              },
            ),
            SizedBox(height: 20),


            Text("Número de Minas:"),
            SizedBox(
              height: 80, // Aumenta la altura del selector
              child: CupertinoSegmentedControl<int>(
                groupValue: _selectedMineCount,
                children: const {
                  0: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("5"),
                  ),
                  1: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("10"),
                  ),
                  2: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("20"),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _selectedMineCount = value;
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            CupertinoButton.filled(
              child: Text("Aplicar Configuración"),
              onPressed: () {
                  
              },
            ),
          ],
        ),
      ),
    );
  }
}