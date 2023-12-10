import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_classification_proj/analyzing_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  static const MethodChannel pytorchChannel =
      MethodChannel('com.pytorch_channel');
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _pickedImages = [];
  Model? _imageModel;
  dynamic? _imagePrediction;
  List<List<String>> labels = [
    ['1950', '1960', '1970', '1980', '1990', '2000', '2010', '2019'],
    [
      "ivy",
      "feminine",
      "classic",
      "mods",
      "minimal",
      "popart",
      "space",
      "hippie",
      "disco",
      "military",
      "punk",
      "bold",
      "powersuit",
      "bodyconscious",
      "hiphop",
      "kitsch",
      "lingerie",
      "grunge",
      "metrosexual",
      "cityglam",
      "oriental",
      "ecology",
      "sportivecasual",
      "athleisure",
      "lounge",
      "normcore",
      "genderless"
    ],
    ['M', 'W'],
    ["전혀 선호하지 않음", "선호하지 않음", "선호함", "매우 선호함"],
    ["봄/가을", "여름", "겨울"],
    ["출근", "데이트", "행사", "사교모임", "일상 생활", "레저 스포츠", "여행/휴가", "기타"],
    ["1", "2", "3"],
    ["1", "2"],
    ["1", "2"],
    ["1", "2"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["0", "1"],
    ["1", "2"],
  ];
  List<List<double>>? _prediction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  // 카메라, 갤러리에서 이미지 1개 불러오기
  // ImageSource.galley , ImageSource.camera
  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImages.add(image);
    });
  }

  // 이미지 여러개 불러오기
  void getMultiImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _pickedImages.addAll(images);
      });
    }
  }

  //load your model
  Future loadModel() async {
    String pathImageModel = 'assets/models/best2.pt';

    try {
      _imageModel = await PyTorchMobile.loadModel(pathImageModel);
    } on PlatformException {
      print("only supported for android and ios so far");
    }
  }

  //run an image model
  Future runImageModel(String imagePath) async {
    _imagePrediction =
        await _imageModel!.getImagePredictionList(File(imagePath), 224, 224);
    List<List<double>> result = getResult(_imagePrediction);
    setState(() {
      _prediction = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              _imageLoadButtons(),
              const SizedBox(height: 20),
              _gridPhoto(),
              IconButton(
                  onPressed: () async {
                    await runImageModel(_pickedImages[0]!.path);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AnalyzingScreen(
                              prediction: _prediction!,
                              label: labels,
                            )));
                  },
                  icon: Icon(Icons.radio_button_checked))
            ],
          ),
        ),
      ),
    );
  }

  // 화면 상단 버튼
  Widget _imageLoadButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: const Text('Image'),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getMultiImage(),
              child: const Text('Multi Image'),
            ),
          ),
        ],
      ),
    );
  }

  // 불러온 이미지 gridView
  Widget _gridPhoto() {
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: _pickedImages
                  .where((element) => element != null)
                  .map((e) => _gridPhotoItem(e!))
                  .toList(),
            )
          : const SizedBox(),
    );
  }

  Widget _gridPhotoItem(XFile e) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(e.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pickedImages.remove(e);
                });
              },
              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<List<double>> getResult(data) {
    List<List<double>> results = [];
    int totalIndex = 0;

    for (int i = 0; i < labels.length; i++) {
      List<double> temp = [];
      for (int j = 0; j < labels[i].length; j++) {
        temp.add(data[totalIndex]);

        totalIndex++;
      }
      results.add(temp);
    }
    for (int i = 0; i < results.length; i++) {
      results[i] = softmax(results[i]);
    }

    return results;
  }

  List<double> softmax(List<double> input) {
    double sumExp = 0.0;

    for (double value in input) {
      sumExp += exp(value);
    }

    List<double> result = [];
    for (double value in input) {
      result.add(exp(value) / sumExp);
    }

    return result;
  }
}
