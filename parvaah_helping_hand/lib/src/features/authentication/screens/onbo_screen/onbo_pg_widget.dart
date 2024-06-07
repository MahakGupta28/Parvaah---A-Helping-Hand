import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/features/authentication/models/model_onbo.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(tDefaultSize),
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(model.image),
            height: size.height * 0.45,
          ),
          Column(
            children: [
              Text(
                model.title,
                style: const TextStyle(
                    fontSize: 28.0,
                    color: Color.fromARGB(255, 25, 3, 39),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                model.subTitle,
                style: const TextStyle(
                    fontSize: 15.0, color: Color.fromARGB(255, 25, 3, 39)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            model.counterText,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 80.0,
          )
        ],
      ),
    );
  }
}
