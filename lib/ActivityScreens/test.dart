import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();

  @override
  void initState() {
    super.initState();

    menu = PopupMenu(items: [
      // MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
      // MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)),
      MenuItem(
          title: 'Mail',
          image: Icon(
            Icons.mail,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Power',
          image: Icon(
            Icons.power,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Setting',
          image: Icon(
            Icons.settings,
            color: Colors.white,
          )),
      MenuItem(
          title: 'PopupMenu',
          image: Icon(
            Icons.menu,
            color: Colors.white,
          ))
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  void onDismissOnlyBeCalledOnce() {
    menu.show(widgetKey: btnKey3);
  }

  void onGesturesDemo() {
    menu.dismiss();
    return;
  }

  void checkState(BuildContext context) {
    final snackBar = new SnackBar(content: new Text('这是一个SnackBar!'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          // MenuItem(
          //     title: 'Home',
          //     // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
          //     image: Icon(
          //       Icons.home,
          //       color: Colors.white,
          //     )),
          // MenuItem(
          //     title: 'Mail',
          //     image: Icon(
          //       Icons.mail,
          //       color: Colors.white,
          //     )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey);
  }

  //
  void customBackground() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        // maxColumn: 2,
        items: [
          MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
          MenuItem(
              title: 'Home',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.home,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Mail',
              image: Icon(
                Icons.mail,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey2);
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: MaterialButton(
              height: 45.0,
              key: btnKey,
              onPressed: maxColumn,
              child: Text('Show Menu1'),
            ),
          ),
          Container(
            child: MaterialButton(
              key: btnKey2,
              height: 45.0,
              onPressed: customBackground,
              child: Text('Show Menu2'),
            ),
          ),
          Container(
            child: MaterialButton(
              key: btnKey3,
              height: 45.0,
              onPressed: onDismissOnlyBeCalledOnce,
              child: Text('Show Menu3'),
            ),
          ),
          Container(
            child: MaterialButton(
              height: 30.0,
              child: Text('Gestures Demo'),
              onPressed: onGesturesDemo,
            ),
          )
        ],
      ),
    );
  }
}
