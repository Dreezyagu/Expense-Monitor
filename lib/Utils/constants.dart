import 'package:flutter/cupertino.dart';

Color white = Color(0xffffffff);
Color black = Color(0xff000000);
const dark = Color(0xFF242B33);
const lightGrey = Color(0xFFafb7bd);

extension CustomContext on BuildContext {
  double height([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double width([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}
