import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/bar_chart.dart';
import 'package:image_classification_proj/graphs/pie_chart.dart';
import 'package:image_classification_proj/graphs/serailze_data.dart';
import 'package:image_classification_proj/graphs/text_bubble_chart.dart';

class AnalyzingScreen extends StatefulWidget {
  List<List<double>> prediction;
  List<List<String>> label;
  AnalyzingScreen({super.key, required this.prediction, required this.label});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey fashionYearKey = GlobalKey();
  final GlobalKey fashionStyleKey = GlobalKey();
  final GlobalKey fashionGenderKey = GlobalKey();
  final GlobalKey fashionFavorKey = GlobalKey();
  final GlobalKey fashionWeatherKey = GlobalKey();
  List<Widget> widgets = [];
  @override
  initState() {
    super.initState();
    _buildWidgetsSequentially();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              children: widgets,
            ),
            SizedBox(
              height: 800,
            )
          ]),
        ),
      ),
    );
  }

  Widget resultBlock(
      String title, String content, Widget graph, GlobalKey key) {
    return SizedBox(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '${title}\n${content}',
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              repeatForever: false,
              isRepeatingAnimation: false,
              pause: const Duration(milliseconds: 10),
              displayFullTextOnTap: true,
              stopPauseOnTap: false,
            ),
            graph
          ],
        ),
      ),
    );
  }

  Future<void> _buildWidgetsSequentially() async {
    await _addWidgetDelayed(
      Duration(seconds: 0),
      resultBlock(
          '유행한 패션의 연도를 예측했습니다.',
          '',
          SerialDataGraph(
            labels: widget.label[0],
            values: widget.prediction[0],
          ),
          fashionYearKey),
    );

    await _addWidgetDelayed(
      Duration(seconds: 2),
      resultBlock(
          '유행한 패션의 스타일을 예측했습니다.',
          '',
          Barchart(
            labels: widget.label[1],
            values: widget.prediction[1],
          ),
          fashionStyleKey),
    );

    await _addWidgetDelayed(
      Duration(seconds: 2),
      resultBlock(
          '유행한 패션의 성별을 예측했습니다.',
          '',
          PieChart(
            labels: widget.label[2],
            values: widget.prediction[2],
          ),
          fashionGenderKey),
    );
    await _addWidgetDelayed(
      Duration(seconds: 2),
      resultBlock(
          '패션의 선호도를 예측했습니다.',
          '',
          PieChart(
            maxNum: 4,
            labels: widget.label[3],
            values: widget.prediction[3],
          ),
          fashionFavorKey),
    );
    await _addWidgetDelayed(
      Duration(seconds: 2),
      resultBlock(
          '어울리는 계절을 예측했습니다.',
          '',
          PieChart(
            maxNum: 3,
            labels: widget.label[4],
            values: widget.prediction[4],
          ),
          fashionWeatherKey),
    );
  }

  // Future<void> autoScroll(GlobalKey targetKey) async {
  //   RenderBox targetRenderBox =
  //       targetKey.currentContext?.findRenderObject() as RenderBox;

  //   await scrollController.animateTo(
  //     targetRenderBox.localToGlobal(Offset.infinite).dy,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  Future<void> _addWidgetDelayed(Duration duration, Widget widget) async {
    await Future.delayed(duration);
    setState(() {
      widgets.add(widget);
    });
  }
}
