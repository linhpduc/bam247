import 'package:batt247/utils/database.dart';
import 'package:bloc/bloc.dart';
import 'source_event.dart';
import 'source_state.dart';

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final AppDB db;

  SourceBloc(this.db) : super(SourceInitial());

  @override
  Stream<SourceState> mapEventToState(SourceEvent event) async* {
    if (event is LoadSources) {
      yield SourcesLoading();
      try {
        final sources = await db.readAllSource();
        yield SourcesLoaded(sources);
      } catch (e) {
        yield SourceError(e.toString());
      }
    } else if (event is SelectSource) {
      try {
        final Source = await db.readSource(event.sourceId);
        yield SourceSelected(Source);
      } catch (e) {
        yield SourceError(e.toString());
      }
    }
  }
}
