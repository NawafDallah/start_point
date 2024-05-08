import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../config/theme/theme_mode_cache_helper.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ChangeThemeModeState> {
  final ThemeModeCacheHelper _themeModeCacheHelper;
  ThemeModeCubit({required ThemeModeCacheHelper themeModeCacheHelper})
      : _themeModeCacheHelper = themeModeCacheHelper,
        super(const ChangeThemeModeState(themeMode: ThemeMode.system));

  void getSavedThemeMode() {
    final String cachedThemeMode = _themeModeCacheHelper.getCachedThemeMode();
    if (cachedThemeMode == 'dark') {
      emit(const ChangeThemeModeState(themeMode: ThemeMode.dark));
    } else if (cachedThemeMode == 'light') {
      emit(const ChangeThemeModeState(themeMode: ThemeMode.light));
    } else {
      emit(const ChangeThemeModeState(themeMode: ThemeMode.system));
    }
  }

  void changeThemeMode(String themeMode) {
    _themeModeCacheHelper.cacheThemeMode(themeMode);
    emit(themeMode == 'system'
        ? const ChangeThemeModeState(themeMode: ThemeMode.system)
        : themeMode == 'dark'
            ? const ChangeThemeModeState(themeMode: ThemeMode.dark)
            : const ChangeThemeModeState(themeMode: ThemeMode.light));
  }
}
