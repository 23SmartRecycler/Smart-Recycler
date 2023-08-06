import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/login.dart';
import 'package:smartrecycler/content.dart';
import 'package:smartrecycler/profile.dart';
import 'package:smartrecycler/setting.dart';
import 'package:smartrecycler/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '페이지 목록 (확인용)'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            UseableIcon(),
            TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));}, child: Text('login')),
            TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPage()));}, child: Text('content')),
            TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));}, child: Text('profile')),
            TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));}, child: Text('setting')),
            TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));}, child: Text('sign_up')),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UseableIcon extends StatelessWidget {
  const UseableIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: 80,
        child: Column(
          children: [
            Container(),

          ],
        )
    );
  }
}
