import '../data/activity_model.dart';
import '../service/display_activity_service.dart';

class DisplayActivityController {
  final DisplayActivityService _service = DisplayActivityService();

  Stream<List<ActivityModel>> get activitiesStream =>
      _service.streamAllActivities();
}