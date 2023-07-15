import 'package:flutter/material.dart';
import '../../infrastructure/theme/colors.theme.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        children: <Widget>[
          ModalBarrier(
            dismissible: false,
            color: Colors.grey.withOpacity(.3),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(ColorsTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
