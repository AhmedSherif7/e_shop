import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/colors_manager.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [Icon(Icons.home), Text('Contact')],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [Icon(Icons.home), Text('Contact')],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [Icon(Icons.home), Text('Contact')],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                  height: 120,
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.home,
                          size: 45,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width / 8,
                          color: Colors.green,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 120.0 / 8),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Contact'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
