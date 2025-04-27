// Define a generic interface for all use cases
abstract class UseCase<Type, Params> {
  Future<Type> call([Params params]);
}

class NoParams {
  const NoParams();
}
