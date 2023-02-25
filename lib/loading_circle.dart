import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: Lottie.network("https://assets8.lottiefiles.com/packages/lf20_qxemgrnw.json"),
      ),
    );
  }
}