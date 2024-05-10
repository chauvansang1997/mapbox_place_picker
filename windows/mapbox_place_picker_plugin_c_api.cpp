#include "include/mapbox_place_picker/mapbox_place_picker_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "mapbox_place_picker_plugin.h"

void MapboxPlacePickerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  mapbox_place_picker::MapboxPlacePickerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
