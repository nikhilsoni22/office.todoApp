part of 'image_pickerr_bloc.dart';

class ImagePickerState extends Equatable {
  final XFile? image;

  const ImagePickerState({
    this.image,
  });

  ImagePickerState copyWith({XFile? image, XFile? clearImage}) {
    return ImagePickerState(image: image ?? this.image);
  }

  @override
  List<Object?> get props => [image];
}