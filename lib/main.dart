import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mpsc_demo/root_widget.dart';
import 'package:provider/provider.dart';

import 'utils/app_state_notifier.dart';
import 'datamodels/user_profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(
    enabled: foundation.kDebugMode,
    builder: (context) => ParentApp(), // Wrap your app
  ));
}

class ParentApp extends StatelessWidget {
  final Map<String, dynamic> idToken = {};
  final Map<dynamic, dynamic> profile = {};
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<UserProfile>(
          create: (_) => UserProfile(idToken, profile)),
      ChangeNotifierProvider<AppStateNotifier>(
          create: (_) => AppStateNotifier())
    ], child: MyApp());
  }
}
