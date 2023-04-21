import 'package:get/get.dart';

class AvpTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'settings_title': 'Settings',
          'settings_title_screen_orientation': 'Default Screen Orientation',
          'settings_subtitle_screen_orientation':
              'Lock screen orientation, ignore media aspect ratio',
          'settings_title_open_external': "Open in External",
          'settings_subtitle_open_external':
              "Always open media files on external player",
          'settings_title_screen_orientation_widget':
              'Choose Default Orientation',
          'settings_title_screen_orientation_auto': 'Auto',
          'settings_title_screen_orientation_portrait': 'Portrait',
          'settings_title_screen_orientation_landscape': 'Landscape',
        },
      };
}
