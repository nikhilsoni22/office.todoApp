import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/image_repository.dart';

part 'image_pickerr_event.dart';
part 'image_pickerr_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvents, ImagePickerState> {
  PickImageFromDevice pickImageFromDevice = PickImageFromDevice();
  XFile? image;

  ImagePickerBloc() : super(ImagePickerState()) {
    on<PickImageFromGallery>(_pickImageFromGallery);
    on<ClearImage>(_ClearImage);
  }

  void _pickImageFromGallery(PickImageFromGallery events, Emitter<ImagePickerState> emit) async {
    image = await pickImageFromDevice.pickImageFromGallery();
    if (image != null) {
      print("image fetched successfully ${image!.path}");
    } else {
      print("Image selection canceled or no image selected.");
    }
    emit(state.copyWith(image: image));
  }

  void _ClearImage(ClearImage events, Emitter<ImagePickerState> emit)async{
    image = null;
    emit(state.copyWith(image: null));
    print("${state.image!.path}---------------> image");
  }
}