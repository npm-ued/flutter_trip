import 'package:flutter/material.dart';
import 'package:flutter_base_demo/app_lifecycle.dart';
import 'package:flutter_base_demo/flutter_layout_page.dart';
import 'package:flutter_base_demo/flutter_widget_lifecycle.dart';
import 'package:flutter_base_demo/gesture_page.dart';
import 'package:flutter_base_demo/launch_page.dart';
import 'package:flutter_base_demo/less_group_page.dart';
import 'package:flutter_base_demo/photo_app_page.dart';
import 'package:flutter_base_demo/plugin_use.dart';
import 'package:flutter_base_demo/res_page.dart';
import 'package:flutter_base_demo/statefull_group_page.dart';

void main() => runApp(DynamicTheme());

class DynamicTheme extends StatefulWidget {
  @override
  _DynamicThemeState createState() => _DynamicThemeState();
}

class _DynamicThemeState extends State<DynamicTheme> {
  Brightness _brightness = Brightness.light;
  ///字体下载地址：https://fonts.google.com/specimen/Rubik+Mono+One?selection.family=Rubik+Mono+One
  ///更多参考：https://flutter.dev/docs/cookbook/design/fonts
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
//          fontFamily: 'RubikMonoOne',//将该字体应用到全局
          brightness:_brightness,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('如何创建和使用Flutter的路由与导航？'),
          ),
          body: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    if (_brightness == Brightness.dark) {
                      _brightness = Brightness.light;
                    } else {
                      _brightness = Brightness.dark;
                    }
                  });
                },
                child: Text('切换主题abc',style: TextStyle(fontFamily: 'RubikMonoOne'),),
              ),
              RouteNavigator()
            ],
          ),
        ),
        routes: <String, WidgetBuilder>{
          'plugin': (BuildContext context) => PluginUse(),
          'less': (BuildContext context) => LessGroupPage(),
          'ful': (BuildContext context) => StatefulGroup(),
          'layout': (BuildContext context) => FlutterLayoutPage(),
          'gesture': (BuildContext context) => GesturePage(),
          'res': (BuildContext context) => ResPage(),
          'launch': (BuildContext context) => LaunchPage(),
          'widgetLifecycle': (BuildContext context) => WidgetLifecycle(),
          'appLifecycle': (BuildContext context) => AppLifecycle(),
          'photo': (BuildContext context) => PhotoApp(),
        });
  }
}

class RouteNavigator extends StatefulWidget {
  @override
  _RouteNavigatorState createState() => _RouteNavigatorState();
}

class _RouteNavigatorState extends State<RouteNavigator> {
  bool byName = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SwitchListTile(
              title: Text('${byName ? '' : '不'}通过路由名跳转'),
              value: byName,
              onChanged: (value) {
                setState(() {
                  byName = value;
                });
              }),
          _item('如何使用Flutter包和插件？', PluginUse(), 'plugin'),
          _item('StatelessWidget与基础组件', LessGroupPage(), 'less'),
          _item('StatefulWidget与基组件', StatefulGroup(), 'ful'),
          _item('如何进行Flutter布局开发', FlutterLayoutPage(), 'layout'),
          _item('如何检测用户手势以及处理点击事件？', GesturePage(), 'gesture'),
          _item('如何导入和使用Flutter的资源文件？', ResPage(), 'res'),
          _item('如何打开第三方应用？', LaunchPage(), 'launch'),
          _item('Flutter页面生命周期', WidgetLifecycle(), 'widgetLifecycle'),
          _item('Flutter应用生命周期', AppLifecycle(), 'appLifecycle'),
          _item('【实战尝鲜】拍照APP开发', PhotoApp(), 'photo'),
        ],
      ),
    );
  }

  _item(String title, page, String routeName) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          if (byName) {
            Navigator.pushNamed(context, routeName);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          }
        },
        child: Text(title),
      ),
    );
  }
}
