//import 'package:flutter/material.dart';
//import 'package:libmate/views/drawer.dart';
//
//class _PopupContentState extends State<PopupContent> {
//  @override
//  void initState() {
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: widget.content,
//    );
//  }
//  showPopup(BuildContext context, Widget widget, String title,
//      {BuildContext popupContext}) {
//    Navigator.push(
//      context,
//      PopupLayout(
//        top: 30,
//        left: 30,
//        right: 30,
//        bottom: 50,
//        child: PopupContent(
//          content: Scaffold(
//            appBar: AppBar(
//              title: Text(title),
//              leading: new Builder(builder: (context) {
//                return IconButton(
//                  icon: Icon(Icons.arrow_back),
//                  onPressed: () {
//                    try {
//                      Navigator.pop(context); //close the popup
//                    } catch (e) {}
//                  },
//                );
//              }),
//              brightness: Brightness.light,
//            ),
//            resizeToAvoidBottomPadding: false,
//            body: widget,
//          ),
//        ),
//      ),
//    );
//  }
//  Widget _popupBody() {
//    return Container(
//      child: Text('This is a popup window'),
//    );
//  }
//
//class PopupLayout extends ModalRoute {
//  PopupLayout(
//  {Key key,
//  this.bgColor,
//  @required this.child,
//  this.top,
//  this.bottom,
//  this.left,
//  this.right});
//  }
//  @override
//  Duration get transitionDuration => Duration(milliseconds: 300);
//  @override
//  bool get opaque => false;
//  @override
//  bool get barrierDismissible => false;
//  @override
//  Color get barrierColor =>
//      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;
//  @override
//  String get barrierLabel => null;
//  @override
//  bool get maintainState => false;
//  double top;
//  double bottom;
//  double left;
//  double right;
//  Color bgColor;
//  final Widget child;
//
//  @override
//  Widget buildPage(
//      BuildContext context,
//      Animation<double> animation,
//      Animation<double> secondaryAnimation,
//      ) {
//    if (top == null) this.top = 10;
//    if (bottom == null) this.bottom = 20;
//    if (left == null) this.left = 20;
//    if (right == null) this.right = 20;
//
//    return GestureDetector(
//      onTap: () {
//        // call this method here to hide soft keyboard
//        SystemChannels.textInput.invokeMethod('TextInput.hide');
//      },
//      child: Material( // This makes sure that text and other content follows the material style
//        type: MaterialType.transparency,
//        //type: MaterialType.canvas,
//        // make sure that the overlay content is not cut off
//        child: SafeArea(
//          bottom: true,
//          child: _buildOverlayContent(context),
//        ),
//      ),
//    );
//  }
//  //the dynamic content pass by parameter
//  Widget _buildOverlayContent(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(
//          bottom: this.bottom,
//          left: this.left,
//          right: this.right,
//          top: this.top),
//      child: child,
//    );
//  }
//  @override
//  Widget buildTransitions(BuildContext context, Animation<double> animation,
//      Animation<double> secondaryAnimation, Widget child) {
//    // You can add your own animations for the overlay content
//    return FadeTransition(
//      opacity: animation,
//      child: ScaleTransition(
//        scale: animation,
//        child: child,
//      ),
//    );
//  }
//
//}
//
//class PopupContent extends StatefulWidget {
//  final Widget content;
//
//  PopupContent({
//    Key key,
//    this.content,
//  }) : super(key: key);
//
//  _PopupContentState createState() => _PopupContentState();
//}
//class PopupContent extends StatefulWidget {
//  final Widget content;
//
//  PopupContent({
//    Key key,
//    this.content,
//  }) : super(key: key);
//
//  _PopupContentState createState() => _PopupContentState();
//}
