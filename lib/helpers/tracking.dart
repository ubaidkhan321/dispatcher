import 'globals.dart';
import 'api.dart';

test(user_id, gps_latitude, gps_longitude, gsm_latitude, gsm_longitude,
    bettery) async {
  var res = await api.set_track(user_id, gps_latitude, gps_longitude,
      gsm_latitude, gsm_longitude, bettery);
  return res;
}
