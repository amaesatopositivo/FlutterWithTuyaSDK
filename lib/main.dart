import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget()
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  static const platform = const MethodChannel('com.ale.teste/login');

  String _login = 'Login state None';
  
  _MyStatefulWidgetState(){
    _getHomeBeans();
    _getLoginStatus();
  }

  Future<void> _getLoginStatus() async {
    bool statusLogin;
    try {
      print("CLICK _getLoginStatus");
      final bool result = await platform.invokeMethod('isLogged');
      statusLogin = result;
    } on PlatformException catch (e) {
      print("Deu ERRO: ${e.message}");
      statusLogin = false;
    }

    setState(() {
      _login = "Logged: $statusLogin";
    });
  }

  var _homeBeans;

  Future<void> _getHomeBeans() async {
    var homeBeans;
    try {
      print("CLICK _getLoginStatus");
      final String result = await platform.invokeMethod('getHomeBeans');
      print(result);
      homeBeans = result;
      homeBeans = json.decode(result);
    } on PlatformException catch (e) {
      print("Deu ERRO: ${e.message}");
    }

    setState(() {
      print("HOME BEANS JSON $homeBeans");
      _homeBeans = homeBeans;
    });
  }



  List<Widget> getHomeBeans(){
    var listResult=List<Widget>();
    _homeBeans.forEach((homeBean) {
      listResult.add(SimpleDialogOption(
        onPressed: () {
          Scaffold.of(this.context).showSnackBar(SnackBar(
            content: Text(homeBean['name']),
          ));

        },
        child: Row(
          children: <Widget>[
            Text(homeBean['name']),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
            )
          ],
        ),
      )
      );
    });
    if(listResult.length==0){
      listResult.add(SimpleDialogOption(
        onPressed: () {
          Scaffold.of(this.context).showSnackBar(SnackBar(
            content: Text('Nenhum'),
          ));

        },
        child: Row(
          children: <Widget>[
            Text('Nenhum'),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
            )
          ],
        ),
      ));
    }
    return listResult;
  }

  Future<void> _selectHomeBean() async {
    print("Click");
    switch (await showDialog<Teste>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Ambientes'),
            children: getHomeBeans(),
          );
        })) {
    }
  }

  @override
  Widget build(BuildContext context) {
    var divHeight = MediaQuery.of(context).size.height;
    var _currentSelection = _homeBeans != null ? _homeBeans[0]['name']:'';
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [Colors.blueAccent, Colors.greenAccent]),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5.0)],
            color: Colors.blueAccent),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 25),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.white,
                        child: Text(_currentSelection),
                        onPressed: () {
                          _selectHomeBean();
                        },
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, top:30),
              child: Text(_login),
            )
          ],
        ),
        height: divHeight / 2 * 0.25,
      ),
    );
  }
}

Scaffold menuScaffold(){
  var _currentSelection = "Casa";
  return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [Colors.blueAccent, Colors.greenAccent]),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5.0)],
            color: Colors.blueAccent),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 25),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.white,
                        child: Text(_currentSelection),
                        onPressed: () {
                        },
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
          ],
        ),
        height: 80,
      ),
    );
}


class Teste {
  var ale = "Alexandre";
}

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const MyCustomAppBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(30),
            child: AppBar(
                    title: Container(
                      color: Colors.white,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.verified_user),
                        onPressed: () => null,
                      ),
                    ],
                  ) ,
          ),
        ),
      ],
    );
  }
  
 @override
  Size get preferredSize => Size.fromHeight(height);
}
