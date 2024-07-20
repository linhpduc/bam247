import 'package:batt247/models/sources.dart';

abstract class SourceState {}

class SourceInitial extends SourceState {}
class SourcesLoading extends SourceState {}
class SourcesLoaded extends SourceState {
  final List<SourceModel> Sources;
  SourcesLoaded(this.Sources);
}
class SourceSelected extends SourceState {
  final SourceModel Source;
  SourceSelected(this.Source);
}
class SourceError extends SourceState {
  final String message;
  SourceError(this.message);
}
