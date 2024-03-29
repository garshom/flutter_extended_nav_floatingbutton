import 'dart:math';

import 'package:flutter/material.dart';

import 'navigation_menu_button_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
          ],
        ),
      ),
      
      /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[400],
        onPressed: (){

        },
        child: Icon(Icons.menu,color: Colors.white,),
      ), 
      */

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.orange[400],
        backgroundColor: Colors.white,
        onTap: (index){
          setState((){
            
          });
        },
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.home, size:24,),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),

          new BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle, size:24,),
              title: Text(
                'Wallets',
                style: TextStyle(fontWeight: FontWeight.w500),

              )),
          
          new BottomNavigationBarItem(
              icon: Icon(Icons.school, size:24),
              title: Text(
                'Payments',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
              
          new BottomNavigationBarItem(
              icon: Icon(Icons.payment, size:24),
              title: Text(
                'Transactions',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),

        ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ExtendedNavigationButton(
        elevation: 0,
        navButtonColor: Colors.blue[400],
        navButtonIconColor: Colors.white,
        menuButtons: [
          MenuButtonModel(
            icon: Icons.person_add,
            label: "Profile",
            onTap: (){
              print("profile");
            }
          ),

          MenuButtonModel(
            icon: Icons.account_balance_wallet,
            label: "Wallets",
            onTap: (){
              print("Wallets");
            }
          ),
          MenuButtonModel(
            icon: Icons.payment,
            label: "Cards",
            onTap: (){
              print("Cards");
            }
          ),
          MenuButtonModel(
            icon: Icons.history,
            label: "Transactions",
            onTap: (){
              print("Transactions");
            }
          ),
          MenuButtonModel(
            icon: Icons.settings_applications,
            label: "Settings",
            onTap: (){
              print("Settings");
            }
          ),
          MenuButtonModel(
            icon: Icons.person_pin,
            label: "Users",
            onTap: (){}
          ),
          null,
          MenuButtonModel(
            icon: Icons.directions_car,
            label: "Travel",
            onTap: (){}
          ),
          null,
        ],
      )
      
    );
  }


  
}

