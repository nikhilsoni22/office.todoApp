part of 'image_pickerr_bloc.dart';

abstract class ImagePickerEvents extends Equatable {
  const ImagePickerEvents();

  @override
  List<Object> get props => [];
}

class PickImageFromGallery extends ImagePickerEvents {}

class ClearImage extends ImagePickerEvents{}