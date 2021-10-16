import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class AugementedImages extends StatefulWidget {
  const AugementedImages({Key? key}) : super(key: key);

  @override
  _AugementedImagesState createState() => _AugementedImagesState();
}

class _AugementedImagesState extends State<AugementedImages> {
  late ArCoreController arCoreController;
  Map<int, ArCoreAugmentedImage> augmentedImagesMap = {};
  whenArCoreViewCreated(ArCoreController coreController) {
    arCoreController = coreController;
    arCoreController.onTrackingImage = controlOnTrackingImage;

    //load the single image

    loadSingleImage();
  }

  loadSingleImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/earth_augmented_image.jpg');
    arCoreController.loadAugmentedImagesDatabase(
      bytes: bytes.buffer.asUint8List(),
    );
  }

  controlOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
      augmentedImagesMap[augmentedImage.index] = augmentedImage;
      //add sphere
      addSphere(augmentedImage);
    }
  }

  addSphere(ArCoreAugmentedImage arCoreAugmentedImage) async {
    final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');
    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      textureBytes: textureBytes.buffer.asUint8List(),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: arCoreAugmentedImage.extentX / 2,
    );
    final node = ArCoreNode(
      shape: sphere,
    );
    arCoreController.addArCoreNodeToAugmentedImage(
        node, arCoreAugmentedImage.index);
  }

  @override
  void dispose() {
    super.dispose();
    arCoreController.dispose();
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
          type: ArCoreViewType.AUGMENTEDIMAGES,
        ));
  }
}
