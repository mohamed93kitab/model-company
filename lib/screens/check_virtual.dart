import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> isRunningInVirtualApp() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  // List of known virtual app package names
  List<String> virtualAppPackageNames = [
    "com.lbe.parallel", // Parallel Space
    "com.parallel.space", // Dual Space
    "com.cloneapp.parallelspace", // Clone App
    "com.lightspeed.babalgharb", // Clone App
  ];

  // Check if the current package name is in the list of virtual app package names
  if (virtualAppPackageNames.contains(packageInfo.packageName)) {
    return true;
  }

  // Additional check for known virtual app fingerprints (if applicable)
  if (androidInfo.fingerprint != null) {
    for (var packageName in virtualAppPackageNames) {
      if (androidInfo.fingerprint.contains(packageName)) {
        return true;
      }
    }
  }

  return false;
}