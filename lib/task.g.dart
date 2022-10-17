// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $TaskLocalAdapter on LocalAdapter<Task> {
  static final Map<String, RelationshipMeta> _kTaskRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kTaskRelationshipMetas;

  @override
  Task deserialize(map) {
    map = transformDeserialize(map);
    return _$TaskFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$TaskToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _tasksFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $TaskHiveLocalAdapter = HiveLocalAdapter<Task> with $TaskLocalAdapter;

class $TaskRemoteAdapter = RemoteAdapter<Task> with JsonServerAdapter<Task>;

final internalTasksRemoteAdapterProvider = Provider<RemoteAdapter<Task>>(
    (ref) => $TaskRemoteAdapter($TaskHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_tasksFinders)));

final tasksRepositoryProvider =
    Provider<Repository<Task>>((ref) => Repository<Task>(ref.read));

extension TaskDataRepositoryX on Repository<Task> {
  JsonServerAdapter<Task> get jsonServerAdapter =>
      remoteAdapter as JsonServerAdapter<Task>;
}

extension TaskRelationshipGraphNodeX on RelationshipGraphNode<Task> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int?,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
