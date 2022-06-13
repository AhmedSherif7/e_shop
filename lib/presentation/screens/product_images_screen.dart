import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/product_images/product_images_cubit.dart';
import '../resources/colors_manager.dart';

class ProductImagesScreen extends StatelessWidget {
  const ProductImagesScreen(this.image, this.index, this.name, {Key? key})
      : super(key: key);

  final String image;
  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductImagesCubit>(
      create: (_) => sl<ProductImagesCubit>()..setImageUrl(image, name),
      child: BlocListener<ProductImagesCubit, ProductImagesState>(
        listener: (context, state) {
          if (state.downloadImageStatus == DownloadImageStatus.error) {
            showToast(
              message: state.errorMessage!,
              state: ToastStates.error,
            );
          } else if (state.downloadImageStatus == DownloadImageStatus.success) {
            showToast(
              message: 'Image saved to this device',
              state: ToastStates.success,
            );
          }
        },
        child: Scaffold(
          backgroundColor: ColorManager.black,
          appBar: AppBar(
            backgroundColor: ColorManager.black,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: ColorManager.black,
              statusBarIconBrightness: Brightness.light,
            ),
            iconTheme: const IconThemeData(
              color: ColorManager.white,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Ionicons.chevron_back,
              ),
            ),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      context.read<ProductImagesCubit>().downloadImage();
                    },
                    icon: const Icon(
                      Icons.download,
                      color: ColorManager.white,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 120.0,
                width: double.infinity,
              ),
              Container(
                color: ColorManager.white,
                height: 400,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: InteractiveViewer(
                    child: Image.network(
                      image,
                      height: 20.0,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
