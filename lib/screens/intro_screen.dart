import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:youllgetit_flutter/screens/internship_selector_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  late Function _goToTab;

  final Color _primaryColor = const Color(0xffffcc5c);
  final Color _secondColor = const Color(0xff3da4ab);

  void _onDonePress() {
    // Navigate to MyHomePage after the intro slides
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InternshipSelectorScreen()),
    );
  }

  void _onTabChangeCompleted(int index) {
    // log("onTabChangeCompleted, index: $index");
  }

  Widget _renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: _primaryColor,
      size: 35.0,
    );
  }

  Widget _renderDoneBtn() {
    return Icon(
      Icons.done,
      color: _primaryColor,
    );
  }

  Widget _renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: _primaryColor,
    );
  }

  ButtonStyle _myButtonStyle() {
    return ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: WidgetStateProperty.all<Color>(const Color(0x33ffcc5c)),
      overlayColor: WidgetStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  List<Widget> _generateListCustomTabs() {
    return List.generate(
      3,
      (index) => Container(
        color: Colors.black26,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
                value: index.toString(),
                icon: Icon(Icons.arrow_downward, color: _secondColor, size: 20),
                elevation: 16,
                style: TextStyle(color: _primaryColor),
                underline: Container(
                  height: 2,
                  color: _secondColor,
                ),
                onChanged: (String? value) {},
                items: ["0", "1", "2"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(color: _secondColor, fontSize: 20)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              "https://picsum.photos/${300 + index}",
              width: 300.0,
              height: 300.0,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Text(
                "Title at index $index",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _secondColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      renderSkipBtn: _renderSkipBtn(),
      skipButtonStyle: _myButtonStyle(),

      renderNextBtn: _renderNextBtn(),
      nextButtonStyle: _myButtonStyle(),

      renderDoneBtn: _renderDoneBtn(),
      onDonePress: _onDonePress,
      doneButtonStyle: _myButtonStyle(),

      indicatorConfig: const IndicatorConfig(
        colorIndicator: Color(0xffffcc5c),
        sizeIndicator: 13.0,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),

      listCustomTabs: _generateListCustomTabs(),
      backgroundColorAllTabs: Colors.white,
      refFuncGoToTab: (refFunc) {
        _goToTab = refFunc;
      },

      scrollPhysics: const BouncingScrollPhysics(),
      onTabChangeCompleted: _onTabChangeCompleted,
    );
  }
}
