import 'package:get_it/get_it.dart';
// Import repository implementations, datasources, use cases, etc. as they are created

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Register dependencies here as the app grows

  // Example:
  // //! Features - Number Trivia
  // // Bloc
  // sl.registerFactory(
  //   () => NumberTriviaBloc(
  //     getConcreteNumberTrivia: sl(),
  //     getRandomNumberTrivia: sl(),
  //     inputConverter: sl(),
  //   ),
  // );

  // // Use cases
  // sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  // sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // // Repository
  // sl.registerLazySingleton<NumberTriviaRepository>(
  //   () => NumberTriviaRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // // Data sources
  // sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
  //   () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  // );

  // sl.registerLazySingleton<NumberTriviaLocalDataSource>(
  //   () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  // );

  // //! Core
  // sl.registerLazySingleton(() => InputConverter());
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // //! External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => DataConnectionChecker());
}
