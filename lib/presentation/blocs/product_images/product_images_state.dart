part of 'product_images_cubit.dart';

enum DownloadImageStatus {
  success,
  error,
}

@immutable
class ProductImagesState extends Equatable {
  final String url;
  final String name;
  final DownloadImageStatus? downloadImageStatus;
  final String? errorMessage;

  const ProductImagesState({
    this.url = '',
    this.name = '',
    this.downloadImageStatus,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        url,
        name,
        downloadImageStatus,
      ];

  ProductImagesState copyWith({
    String? url,
    String? name,
    DownloadImageStatus? downloadImageStatus,
    String? errorMessage,
  }) {
    return ProductImagesState(
      url: url ?? this.url,
      name: name ?? this.name,
      downloadImageStatus: downloadImageStatus ?? this.downloadImageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
