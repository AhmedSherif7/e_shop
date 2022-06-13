import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/use_cases/download_product_image_use_case.dart';

part 'product_images_state.dart';

class ProductImagesCubit extends Cubit<ProductImagesState> {
  final DownLoadProductImageUseCase downLoadProductImageUseCase;

  ProductImagesCubit(this.downLoadProductImageUseCase)
      : super(const ProductImagesState());

  void setImageUrl(String url, String name) {
    emit(
      state.copyWith(
        url: url,
        name: name,
      ),
    );
  }

  void downloadImage() async {
    final result = await downLoadProductImageUseCase(
      DownLoadProductImageUseCaseInput(
        url: state.url,
        name: state.name,
      ),
    );
    result.fold(
      (error) {
        emit(
          state.copyWith(
            downloadImageStatus: DownloadImageStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            downloadImageStatus: DownloadImageStatus.success,
          ),
        );
      },
    );
  }
}
