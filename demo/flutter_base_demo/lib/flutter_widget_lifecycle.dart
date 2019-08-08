import 'package:flutter/material.dart';

///Flutter Widget的生命周期重点讲解StatefulWidget的生命周期
///因为无状态的widget StatelessWidget只有createElement、与build两个生命周期方法
///StatefulWidget的生命周期方法按照时期不同可以分为三组：
///1.初始化时期
///createState、initState
///2.更新期间
///didChangeDependencies、build、didUpdateWidget
///3.销毁期
///deactivate、dispose
///扩展阅读：
///http://www.devio.org/io/flutter_app/img/blog/flutter-widget-lifecycle.png
///https://flutterbyexample.com/stateful-widget-lifecycle/
///提示：本章节的课件文档和说明，可以从课程仓库的文档链接进入到问答区查看哦
class WidgetLifecycle extends StatefulWidget {
  ///当我们构建一个新的StatefulWidget时，这个会立即调用
  ///并且这个方法必须被覆盖
  @override
  _WidgetLifecycleState createState() => _WidgetLifecycleState();
}

class _WidgetLifecycleState extends State<WidgetLifecycle> {
  int _count = 0;

  ///这是创建widget时调用的除构造方法外的第一个方法：
  ///类似于Android的：onCreate() 与iOS的 viewDidLoad()
  ///在这个方法中通常会做一些初始化工作，比如channel的初始化，监听器的初始化等
  @override
  void initState() {
    print('----initState----');
    super.initState();
  }

  ///当依赖的State对象改变时会调用：
  ///a.在第一次构建widget时，在initState（）之后立即调用此方法；
  ///b.如果的StatefulWidgets依赖于InheritedWidget，那么当当前State所依赖InheritedWidget中的变量改变时会再次调用它
  ///拓展：InheritedWidget可以高效的将数据在Widget树中向下传递、共享，可参考：https://book.flutterchina.club/chapter7/inherited_widget.html
  @override
  void didChangeDependencies() {
    print('---didChangeDependencies----');
    super.didChangeDependencies();
  }

  ///这是一个必须实现的方法，在这里实现你要呈现的页面内容：
  ///它会在在didChangeDependencies()之后立即调用；
  ///另外当调用setState后也会再次调用该方法；
  @override
  Widget build(BuildContext context) {
    print('---build-----');
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter页面生命周期'),
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
              child: Text(
                '点我',
                style: TextStyle(fontSize: 26),
              ),
            ),
            Text(_count.toString())
          ],
        ),
      ),
    );
  }

  ///这是一个不常用到的生命周期方法，当父组件需要重新绘制时才会调用；
  ///该方法会携带一个oldWidget参数，可以将其与当前的widget进行对比以便执行一些额外的逻辑，如：
  /// if (oldWidget.xxx != widget.xxx)...
  @override
  void didUpdateWidget(WidgetLifecycle oldWidget) {
    print('----didUpdateWidget-----');
    super.didUpdateWidget(oldWidget);
  }

  ///很少使用，在组件被移除时调用在dispose之前调用
  @override
  void deactivate() {
    print('-----deactivate------');
    super.deactivate();
  }

  ///常用，组件被销毁时调用：
  ///通常在该方法中执行一些资源的释放工作比如，监听器的卸载，channel的销毁等
  @override
  void dispose() {
    print('-----dispose-----');
    super.dispose();
  }
}
