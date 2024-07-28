//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <advance_water_drop_nav_bar/advance_water_drop_nav_bar_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) advance_water_drop_nav_bar_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AdvanceWaterDropNavBarPlugin");
  advance_water_drop_nav_bar_plugin_register_with_registrar(advance_water_drop_nav_bar_registrar);
}
