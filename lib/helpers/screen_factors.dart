//MediaQuery Width
import 'package:flutter/widgets.dart';

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//MediaQuery Height
double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}