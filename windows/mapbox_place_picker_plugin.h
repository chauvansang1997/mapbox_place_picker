#ifndef FLUTTER_PLUGIN_MAPBOX_PLACE_PICKER_PLUGIN_H_
#define FLUTTER_PLUGIN_MAPBOX_PLACE_PICKER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace mapbox_place_picker {

class MapboxPlacePickerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MapboxPlacePickerPlugin();

  virtual ~MapboxPlacePickerPlugin();

  // Disallow copy and assign.
  MapboxPlacePickerPlugin(const MapboxPlacePickerPlugin&) = delete;
  MapboxPlacePickerPlugin& operator=(const MapboxPlacePickerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mapbox_place_picker

#endif  // FLUTTER_PLUGIN_MAPBOX_PLACE_PICKER_PLUGIN_H_
