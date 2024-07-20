// ignore_for_file: non_constant_identifier_names

abstract class SourceEvent {}

class LoadSources extends SourceEvent {}
class SelectSource extends SourceEvent {
  final String sourceId;
  SelectSource(this.sourceId);
}