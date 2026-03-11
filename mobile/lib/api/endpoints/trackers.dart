import 'package:mobile/api/http.dart';
import 'package:mobile/models/tracker_state.dart';

class TrackerApi {
  TrackerApi._();

  static Future<List<TrackerInfo>> getLatestRecievedTrackers() async {
    final res = await Http.dio.get('/v1/map/latest-recieved-trackers');

    final List data = res.data['data'] ?? [];
    return data.map((e) => TrackerInfo.fromJson(e)).toList();
  }
}
