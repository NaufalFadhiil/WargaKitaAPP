import '../data/help_model.dart';
import '../service/display_help_service.dart';

class DisplayHelpController {
  final DisplayHelpService _service = DisplayHelpService();

  Stream<List<HelpData>> get helpRequestsStream =>
      _service.streamAllHelpRequests();
}