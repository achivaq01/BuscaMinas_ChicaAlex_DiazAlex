import 'package:flutter/cupertino.dart';
import 'package:minesweeper/widget_tresenralla.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Partida"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}
