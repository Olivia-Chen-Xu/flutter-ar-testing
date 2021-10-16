import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import "package:vector_math/vector_math_64.dart" as vector;

class AugementedImages extends StatefulWidget {
  const AugementedImages({Key? key}) : super(key: key);

  @override
  _AugementedImagesState createState() => _AugementedImagesState();
}

class _AugementedImagesState extends State<AugementedImages> {
  late ArCoreController arCoreController;

  // Map<int, ArCoreAugmentedImage> augmentedImagesMap = {};
  // whenArCoreViewCreated(ArCoreController coreController) {
  //   arCoreController = coreController;
  //   arCoreController.onTrackingImage = controlOnTrackingImage;

  //   //load the single image

  //   loadSingleImage();
  // }

  // loadSingleImage() async {
  //   final ByteData bytes =
  //       await rootBundle.load('assets/earth_augmented_image.jpg');
  //   arCoreController.loadAugmentedImagesDatabase(
  //     bytes: bytes.buffer.asUint8List(),
  //   );
  // }

  // controlOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
  //   if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
  //     augmentedImagesMap[augmentedImage.index] = augmentedImage;
  //     //add sphere
  //     addSphere(augmentedImage);
  //   }
  // }

  // addSphere(ArCoreAugmentedImage arCoreAugmentedImage) async {
  //   final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');
  //   final material = ArCoreMaterial(
  //     color: const Color.fromARGB(120, 66, 134, 244),
  //     textureBytes: textureBytes.buffer.asUint8List(),
  //   );
  //   final sphere = ArCoreSphere(
  //     materials: [material],
  //     radius: arCoreAugmentedImage.extentX / 2,
  //   );
  //   final node = ArCoreNode(
  //     shape: sphere,
  //   );
  //   arCoreController.addArCoreNodeToAugmentedImage(
  //       node, arCoreAugmentedImage.index);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   arCoreController.dispose();
  // }

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = controlOnPlaneTap;
  }

  void controlOnPlaneTap(List<ArCoreHitTestResult> results) {
    final hit = results.first;

    addImage(hit);
  }

  addImage(ArCoreHitTestResult hitTestResult) async {
    final bytes = (await rootBundle.load('assets/earth_augmented_image.jpg'))
        .buffer
        .asUint8List();

    final imageNew = ArCoreNode(
      image: ArCoreImage(bytes: bytes, width: 60),
      position: hitTestResult.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation:
          hitTestResult.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),
    );

    arCoreController.addArCoreNodeWithAnchor(imageNew);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Augmented Images'),
          centerTitle: true,
        ),
        body: ArCoreView(
          onArCoreViewCreated: whenArCoreViewCreated,
          enableTapRecognizer: true,
        ));
  }
}
