import 'package:dio/dio.dart';
import 'package:e_commerce_n_flutter/config/theme/theme_mode_cache_helper.dart';
import 'package:e_commerce_n_flutter/core/cubits/theme_mode/theme_mode_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/localization/language_cache_helper.dart';
import 'core/cubits/locale/localization_cubit.dart';
import 'core/cubits/network/network_connection_cubit.dart';
import 'features/on_boarding/data/data_sources/static/on_boarding_service.dart';
import 'features/on_boarding/data/repository/on_boarding_repository_imp.dart';
import 'features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'features/on_boarding/domain/use_case/get_on_boarding_list.dart';
import 'features/on_boarding/presentation/bloc/on_boarding_list/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// dio
  sl.registerLazySingleton<Dio>(() => Dio());

  /// SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  ///// core & config /////

  /// INTERNET-CONNECTION-->
  /// core/network-cubit
  sl.registerFactory(() => NetworkConnectionCubit());

  /// LOCALIZATION-->
  /// config/LanguageCacheHelper
  sl.registerFactory(() => LanguageCacheHelper(sharedPreferences: sl()));

  /// core/Localization-cubit
  sl.registerLazySingleton(() => LocalizationCubit(languageCacheHelper: sl()));

  /// THEME_MODE-->
  /// config/ThemeModeCacheHelper
  sl.registerFactory(() => ThemeModeCacheHelper(sharedPreferences: sl()));

  /// core/ThemeMode-cubit
  sl.registerLazySingleton(() => ThemeModeCubit(themeModeCacheHelper: sl()));

  ///// Features /////

  /// on-boarding-->
  _initOnBoarding();
}

_initOnBoarding() {
  /// data sources
  sl
    ..registerFactory<OnBoardingService>(
      () => const OnBoardingServiceImp(),
    )

    /// repository
    ..registerFactory<OnBoardingRepository>(
      () => OnBoardingRepositoryImp(onboardingService: sl()),
    )

    /// use cases
    ..registerFactory(
      () => GetOnBoardingListCase(onBoardingRepository: sl()),
    )

    /// bloc
    ..registerLazySingleton<OnboardingCubit>(
      () => OnboardingCubit(getOnBoardingListCase: sl()),
    );
}
