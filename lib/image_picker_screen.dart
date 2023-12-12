import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_classification_proj/analyzing_screen.dart';
import 'package:image_classification_proj/labels/prediction_label.dart';
import 'package:image_classification_proj/utils/soft_max.dart';
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
  XFile? _pickedImages;
  Model? _imageModel;
  dynamic? _imagePrediction;
  List<List<String>> labels = ImageClassificationLabels.fashion_label;
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
      _pickedImages = image;
    });
  }

  Future loadModel() async {
    String pathImageModel = 'assets/models/best2.pt';

    try {
      _imageModel = await PyTorchMobile.loadModel(pathImageModel);
    } on PlatformException {
      print("오류 발생함");
    }
  }

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
                    await runImageModel(_pickedImages!.path);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AnalyzingScreen(
                              prediction: _prediction!,
                              label: labels,
                              image: File(_pickedImages!.path),
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
            child: IconButton(
              onPressed: () => getImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            child: IconButton(
                onPressed: () => getImage(ImageSource.gallery),
                icon: const Icon(Icons.photo)),
          ),
        ],
      ),
    );
  }

  // 불러온 이미지 gridView
  Widget _gridPhoto() {
    return Expanded(
      child:
          _pickedImages != null ? _imageView(_pickedImages!) : const SizedBox(),
    );
  }

  Widget _imageView(XFile e) {
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
                  _pickedImages = null;
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
}
