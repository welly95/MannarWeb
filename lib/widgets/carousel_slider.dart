import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/size_config.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import '../../constants/styles.dart';
import '../../models/sliders.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<Sliders> slideImage;
  CarouselSliderWidget(this.slideImage);

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    SizeConfig().init(context);

    return CarouselSlider.builder(
      itemCount: widget.slideImage.length,
      carouselController: buttonCarouselController,
      itemBuilder: (ctx, itemIndex, int pageViewIndex) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.5,
              width: SizeConfig.screenWidth,
              child: Image.network(
                widget.slideImage[itemIndex].imageurl!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.black87,
                    child: Text(
                      widget.slideImage[itemIndex].title!,
                      style: TextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  Container(
                    color: Colors.black87,
                    child: Text(
                      widget.slideImage[itemIndex].description!,
                      style: TextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: SizeConfig.screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: IconButton(
                  onPressed: () {
                    buttonCarouselController.previousPage();
                  },
                  icon: Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: SizeConfig.screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: IconButton(
                  onPressed: () {
                    buttonCarouselController.nextPage();
                  },
                  icon: Icon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.teal,
                  ),
                ),
              ),
            )
          ],
        );
      },
      options: CarouselOptions(
        // height: SizeConfig.safeBlockVertical * 32,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 10),
        enlargeCenterPage: true,
        viewportFraction: 0.95,
      ),
    );
  }
}
