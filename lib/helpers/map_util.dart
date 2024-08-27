import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri _url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    // String google_url =
    // 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    print(_url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not open the map.';
    }
  }

  static navigateTo(double lat, double lng) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(lat, lng),
      title: "Location",
    );
  }
}
