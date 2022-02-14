import 'package:chat_app/ui/shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusyOverlay extends StatelessWidget {
  final Widget? child;
  final String? title;
  final bool show;

  const BusyOverlay(
      {Key? key, this.child, this.title = 'Please wait...', this.show = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          child ?? Container(),
          IgnorePointer(
            ignoring: !show,
            child: Opacity(
                opacity: show ? 1.0 : 0.0,
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  alignment: Alignment.center,
                  color: mainColor.withOpacity(0.6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //CircularProgressIndicator(),
                      const CupertinoActivityIndicator(),
                      Text(title ?? "",
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: white)),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
