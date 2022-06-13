import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user_info/user_info_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../loading_widget.dart';
import 'map_bottom_sheet_content.dart';

class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late CameraPosition _initialCameraPosition;
    final Completer<GoogleMapController> _controller = Completer();

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) {
        return Container(
          color: theme.isDarkMode ? ColorManager.grey : ColorManager.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocProvider<UserInfoCubit>.value(
              value: context.read<UserInfoCubit>()..getLocation(),
              child: BlocBuilder<UserInfoCubit, UserInfoState>(
                buildWhen: (previous, current) {
                  return previous.locationStatus != current.locationStatus ||
                      previous.marker != current.marker;
                },
                builder: (context, state) {
                  switch (state.locationStatus) {
                    case LocationStatus.loading:
                    case LocationStatus.handlingAnotherPermissionError:
                      return const Center(
                        child: LoadingWidget(),
                      );
                    case LocationStatus.serviceDisabled:
                      return BottomSheetContent(
                        text: state.errorMessage!,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              ColorManager.indigo,
                            ),
                          ),
                          onPressed: () async {
                            await Geolocator.openLocationSettings();
                          },
                          icon: const Icon(
                            Ionicons.settings_sharp,
                            color: ColorManager.white,
                          ),
                          label: const Text(
                            'Open Settings',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: ColorManager.white,
                              fontFamily: FontFamilyManager.nunitoSans,
                            ),
                          ),
                        ),
                      );
                    case LocationStatus.permissionDenied:
                      return BottomSheetContent(
                        text: state.errorMessage!,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              ColorManager.indigo,
                            ),
                          ),
                          onPressed: () async {
                            await Geolocator.openAppSettings();
                          },
                          icon: const Icon(
                            Ionicons.settings_sharp,
                            color: ColorManager.white,
                          ),
                          label: const Text(
                            'Open App Settings',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: ColorManager.white,
                              fontFamily: FontFamilyManager.nunitoSans,
                            ),
                          ),
                        ),
                      );
                    case LocationStatus.permissionDefinitionNotFound:
                    case LocationStatus.unknownError:
                      return BottomSheetContent(
                        text: state.errorMessage!,
                      );
                    case LocationStatus.connectionTimeout:
                      return BottomSheetContent(
                        text: state.errorMessage!,
                      );
                    case LocationStatus.success:
                      _initialCameraPosition = CameraPosition(
                        target: state.marker!.position,
                        zoom: 16.0,
                      );
                      return Column(
                        children: [
                          Expanded(
                            child: GoogleMap(
                              compassEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              myLocationEnabled: true,
                              initialCameraPosition: _initialCameraPosition,
                              mapType: MapType.normal,
                              markers: {
                                state.marker!,
                              },
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              mapToolbarEnabled: true,
                              onCameraMove: (position) {
                                context
                                    .read<UserInfoCubit>()
                                    .addMarker(position.target);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Ionicons.return_up_back_outline,
                                  color: theme.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.blue,
                                ),
                                label: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: theme.isDarkMode
                                        ? ColorManager.white
                                        : ColorManager.blue,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  context
                                      .read<UserInfoCubit>()
                                      .getAddressDetails();
                                },
                                icon: Icon(
                                  Ionicons.checkmark_circle_outline,
                                  color: theme.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.blue,
                                ),
                                label: Text(
                                  'Select',
                                  style: TextStyle(
                                    color: theme.isDarkMode
                                        ? ColorManager.white
                                        : ColorManager.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
