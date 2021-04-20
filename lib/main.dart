import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();      // to run lines 11-12 before running flutter app.
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>('Friends');    // wait for the box to be opened completely (add await keyword).
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter with Hive',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<String> friendsBox;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<String>("Friends");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter with Hive'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: friendsBox.listenable(),
              builder: (context, Box<String> friends, _){
                return ListView.separated(
                    itemBuilder: (context, index){
                      final key = friends.keys.toList()[index];
                      final value = friends.get(key);

                      return ListTile(
                        title: Text(value,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(key),
                      );
                    },
                    separatorBuilder: (_, index) => Divider() ,
                    itemCount: friends.keys.toList().length
                );
              },
            ),
            // child: Center(
            //   child: FlatButton(
            //     child: Text('Show'),
            //     color: Colors.deepOrangeAccent,
            //     onPressed: () {
            //       print(friendsBox.getAt(0));   //using the index.
            //       print(friendsBox.get("2"));   // using the key of the key-value pair.
            //     },
            //   ),
            // ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text('Add New'),
                  color: Colors.lightGreen,
                  onPressed: () {
                    _idController.clear();
                    _nameController.clear();

                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('ID: '),
                                  TextField(
                                    controller: _idController,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text('Name: '),
                                  TextField(
                                    controller: _nameController,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  FlatButton(
                                    color: Colors.lightGreen,
                                    child: Text('Submit'),
                                    onPressed: (){
                                      final key = _idController.text;
                                      final value = _nameController.text;

                                      friendsBox.put(key, value);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  },
                ),
                FlatButton(
                  child: Text('Update'),
                  color: Colors.green,
                  onPressed: (){
                    _idController.clear();
                    _nameController.clear();

                    showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('ID: '),
                                TextField(
                                  controller: _idController,
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text('Name: '),
                                TextField(
                                  controller: _nameController,
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                FlatButton(
                                  color: Colors.green,
                                  child: Text('Update'),
                                  onPressed: (){
                                    final key = _idController.text;
                                    final value = _nameController.text;

                                    friendsBox.put(key, value);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                FlatButton(
                  child: Text('Delete'),
                  color: Colors.greenAccent,
                  onPressed: (){
                    _idController.clear();
                    _nameController.clear();

                    showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('ID: '),
                                TextField(
                                  controller: _idController,
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                FlatButton(
                                  color: Colors.greenAccent,
                                  child: Text('Delete'),
                                  onPressed: (){
                                    final key = _idController.text;

                                    friendsBox.delete(key);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
