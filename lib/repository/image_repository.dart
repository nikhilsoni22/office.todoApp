import 'package:image_picker/image_picker.dart';

class PickImageFromDevice {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }
}