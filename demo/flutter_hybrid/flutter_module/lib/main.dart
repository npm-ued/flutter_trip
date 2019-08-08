import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp(
      initParams: window.defaultRouteName,
    ));

class MyApp extends StatelessWidget {
  final String initParams;

  const MyApp({Key key, this.initParams}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 混合开发',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter 混合开发',
        initParams: initParams,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.initParams}) : super(key: key);

  final String title;
  final String initParams;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel _eventChannelPlugin =
      EventChannel('EventChannelPlugin');
  String showMessage = "";
  static const MethodChannel _methodChannelPlugin =
      const MethodChannel('MethodChannelPlugin');
  static const BasicMessageChannel<String> _basicMessageChannel =
      const BasicMessageChannel('BasicMessageChannelPlugin', StringCodec());
  bool _isMethodChannelPlugin = false;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = _eventChannelPlugin
        .receiveBroadcastStream('123')
        .listen(_onToDart, onError: _onToDartError);
    //使用BasicMessageChannel接受来自Native的消息，并向Native回复
    _basicMessageChannel
        .setMessageHandler((String message) => Future<String>(() {
              setState(() {
                showMessage = 'BasicMessageChannel:'+message;
              });
              return "收到Native的消息：" + message;
            }));
    super.initState();
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
    super.dispose();
  }

  void _onToDart(message) {
    setState(() {
      showMessage = 'EventChannel:'+message;
    });
  }

  void _onToDartError(error) {
    print(error);
  }

  void _onTextChange(value) async {
    String response;
    try {
      if (_isMethodChannelPlugin) {
        //使用BasicMessageChannel向Native发送消息，并接受Native的回复
        response = await _methodChannelPlugin.invokeMethod('send', value);
      } else {
        response = await _basicMessageChannel.send(value);
      }
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      showMessage = response ?? "";
    });
  }

  void _onChanelChanged(bool value) =>
      setState(() => _isMethodChannelPlugin = value);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        margin: EdgeInsets.only(top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              value: _isMethodChannelPlugin,
              onChanged: _onChanelChanged,
              title: Text(_isMethodChannelPlugin
                  ? "MethodChannelPlugin"
                  : "BasicMessageChannelPlugin"),
            ),
            TextField(
              onChanged: _onTextChange,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            Text(
              '收到初始参数initParams:${widget.initParams}',
              style: textStyle,
            ),
            Text(
              'Native传来的数据：' + showMessage,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
