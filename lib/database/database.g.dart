// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SavedDirectoriesTable extends SavedDirectories
    with TableInfo<$SavedDirectoriesTable, SavedDirectory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedDirectoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<String> savedAt = GeneratedColumn<String>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<String> lastModified = GeneratedColumn<String>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, path, savedAt, lastModified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_directories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedDirectory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedDirectory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedDirectory(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      path:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}path'],
          )!,
      savedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}saved_at'],
          )!,
      lastModified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_modified'],
          )!,
    );
  }

  @override
  $SavedDirectoriesTable createAlias(String alias) {
    return $SavedDirectoriesTable(attachedDatabase, alias);
  }
}

class SavedDirectory extends DataClass implements Insertable<SavedDirectory> {
  final int id;
  final String name;
  final String path;
  final String savedAt;
  final String lastModified;
  const SavedDirectory({
    required this.id,
    required this.name,
    required this.path,
    required this.savedAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['path'] = Variable<String>(path);
    map['saved_at'] = Variable<String>(savedAt);
    map['last_modified'] = Variable<String>(lastModified);
    return map;
  }

  SavedDirectoriesCompanion toCompanion(bool nullToAbsent) {
    return SavedDirectoriesCompanion(
      id: Value(id),
      name: Value(name),
      path: Value(path),
      savedAt: Value(savedAt),
      lastModified: Value(lastModified),
    );
  }

  factory SavedDirectory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedDirectory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      path: serializer.fromJson<String>(json['path']),
      savedAt: serializer.fromJson<String>(json['savedAt']),
      lastModified: serializer.fromJson<String>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'path': serializer.toJson<String>(path),
      'savedAt': serializer.toJson<String>(savedAt),
      'lastModified': serializer.toJson<String>(lastModified),
    };
  }

  SavedDirectory copyWith({
    int? id,
    String? name,
    String? path,
    String? savedAt,
    String? lastModified,
  }) => SavedDirectory(
    id: id ?? this.id,
    name: name ?? this.name,
    path: path ?? this.path,
    savedAt: savedAt ?? this.savedAt,
    lastModified: lastModified ?? this.lastModified,
  );
  SavedDirectory copyWithCompanion(SavedDirectoriesCompanion data) {
    return SavedDirectory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      path: data.path.present ? data.path.value : this.path,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
      lastModified:
          data.lastModified.present
              ? data.lastModified.value
              : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedDirectory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('savedAt: $savedAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, path, savedAt, lastModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedDirectory &&
          other.id == this.id &&
          other.name == this.name &&
          other.path == this.path &&
          other.savedAt == this.savedAt &&
          other.lastModified == this.lastModified);
}

class SavedDirectoriesCompanion extends UpdateCompanion<SavedDirectory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> path;
  final Value<String> savedAt;
  final Value<String> lastModified;
  const SavedDirectoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  SavedDirectoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String path,
    required String savedAt,
    required String lastModified,
  }) : name = Value(name),
       path = Value(path),
       savedAt = Value(savedAt),
       lastModified = Value(lastModified);
  static Insertable<SavedDirectory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? path,
    Expression<String>? savedAt,
    Expression<String>? lastModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (savedAt != null) 'saved_at': savedAt,
      if (lastModified != null) 'last_modified': lastModified,
    });
  }

  SavedDirectoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? path,
    Value<String>? savedAt,
    Value<String>? lastModified,
  }) {
    return SavedDirectoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      savedAt: savedAt ?? this.savedAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<String>(savedAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<String>(lastModified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedDirectoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('savedAt: $savedAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }
}

class $GitCredentialsTable extends GitCredentials
    with TableInfo<$GitCredentialsTable, GitCredential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GitCredentialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientSecretMeta = const VerificationMeta(
    'clientSecret',
  );
  @override
  late final GeneratedColumn<String> clientSecret = GeneratedColumn<String>(
    'client_secret',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apiUrlMeta = const VerificationMeta('apiUrl');
  @override
  late final GeneratedColumn<String> apiUrl = GeneratedColumn<String>(
    'api_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    token,
    clientId,
    clientSecret,
    apiUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'git_credentials';
  @override
  VerificationContext validateIntegrity(
    Insertable<GitCredential> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('client_secret')) {
      context.handle(
        _clientSecretMeta,
        clientSecret.isAcceptableOrUnknown(
          data['client_secret']!,
          _clientSecretMeta,
        ),
      );
    }
    if (data.containsKey('api_url')) {
      context.handle(
        _apiUrlMeta,
        apiUrl.isAcceptableOrUnknown(data['api_url']!, _apiUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GitCredential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GitCredential(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      token:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}token'],
          )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      clientSecret: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_secret'],
      ),
      apiUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_url'],
      ),
    );
  }

  @override
  $GitCredentialsTable createAlias(String alias) {
    return $GitCredentialsTable(attachedDatabase, alias);
  }
}

class GitCredential extends DataClass implements Insertable<GitCredential> {
  final int id;
  final String name;
  final String token;
  final String? clientId;
  final String? clientSecret;
  final String? apiUrl;
  const GitCredential({
    required this.id,
    required this.name,
    required this.token,
    this.clientId,
    this.clientSecret,
    this.apiUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['token'] = Variable<String>(token);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || clientSecret != null) {
      map['client_secret'] = Variable<String>(clientSecret);
    }
    if (!nullToAbsent || apiUrl != null) {
      map['api_url'] = Variable<String>(apiUrl);
    }
    return map;
  }

  GitCredentialsCompanion toCompanion(bool nullToAbsent) {
    return GitCredentialsCompanion(
      id: Value(id),
      name: Value(name),
      token: Value(token),
      clientId:
          clientId == null && nullToAbsent
              ? const Value.absent()
              : Value(clientId),
      clientSecret:
          clientSecret == null && nullToAbsent
              ? const Value.absent()
              : Value(clientSecret),
      apiUrl:
          apiUrl == null && nullToAbsent ? const Value.absent() : Value(apiUrl),
    );
  }

  factory GitCredential.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GitCredential(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      token: serializer.fromJson<String>(json['token']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      clientSecret: serializer.fromJson<String?>(json['clientSecret']),
      apiUrl: serializer.fromJson<String?>(json['apiUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'token': serializer.toJson<String>(token),
      'clientId': serializer.toJson<String?>(clientId),
      'clientSecret': serializer.toJson<String?>(clientSecret),
      'apiUrl': serializer.toJson<String?>(apiUrl),
    };
  }

  GitCredential copyWith({
    int? id,
    String? name,
    String? token,
    Value<String?> clientId = const Value.absent(),
    Value<String?> clientSecret = const Value.absent(),
    Value<String?> apiUrl = const Value.absent(),
  }) => GitCredential(
    id: id ?? this.id,
    name: name ?? this.name,
    token: token ?? this.token,
    clientId: clientId.present ? clientId.value : this.clientId,
    clientSecret: clientSecret.present ? clientSecret.value : this.clientSecret,
    apiUrl: apiUrl.present ? apiUrl.value : this.apiUrl,
  );
  GitCredential copyWithCompanion(GitCredentialsCompanion data) {
    return GitCredential(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      token: data.token.present ? data.token.value : this.token,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      clientSecret:
          data.clientSecret.present
              ? data.clientSecret.value
              : this.clientSecret,
      apiUrl: data.apiUrl.present ? data.apiUrl.value : this.apiUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GitCredential(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('token: $token, ')
          ..write('clientId: $clientId, ')
          ..write('clientSecret: $clientSecret, ')
          ..write('apiUrl: $apiUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, token, clientId, clientSecret, apiUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GitCredential &&
          other.id == this.id &&
          other.name == this.name &&
          other.token == this.token &&
          other.clientId == this.clientId &&
          other.clientSecret == this.clientSecret &&
          other.apiUrl == this.apiUrl);
}

class GitCredentialsCompanion extends UpdateCompanion<GitCredential> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> token;
  final Value<String?> clientId;
  final Value<String?> clientSecret;
  final Value<String?> apiUrl;
  const GitCredentialsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.token = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientSecret = const Value.absent(),
    this.apiUrl = const Value.absent(),
  });
  GitCredentialsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String token,
    this.clientId = const Value.absent(),
    this.clientSecret = const Value.absent(),
    this.apiUrl = const Value.absent(),
  }) : name = Value(name),
       token = Value(token);
  static Insertable<GitCredential> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? token,
    Expression<String>? clientId,
    Expression<String>? clientSecret,
    Expression<String>? apiUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (token != null) 'token': token,
      if (clientId != null) 'client_id': clientId,
      if (clientSecret != null) 'client_secret': clientSecret,
      if (apiUrl != null) 'api_url': apiUrl,
    });
  }

  GitCredentialsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? token,
    Value<String?>? clientId,
    Value<String?>? clientSecret,
    Value<String?>? apiUrl,
  }) {
    return GitCredentialsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      token: token ?? this.token,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      apiUrl: apiUrl ?? this.apiUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (clientSecret.present) {
      map['client_secret'] = Variable<String>(clientSecret.value);
    }
    if (apiUrl.present) {
      map['api_url'] = Variable<String>(apiUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GitCredentialsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('token: $token, ')
          ..write('clientId: $clientId, ')
          ..write('clientSecret: $clientSecret, ')
          ..write('apiUrl: $apiUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedDirectoriesTable savedDirectories = $SavedDirectoriesTable(
    this,
  );
  late final $GitCredentialsTable gitCredentials = $GitCredentialsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    savedDirectories,
    gitCredentials,
  ];
}

typedef $$SavedDirectoriesTableCreateCompanionBuilder =
    SavedDirectoriesCompanion Function({
      Value<int> id,
      required String name,
      required String path,
      required String savedAt,
      required String lastModified,
    });
typedef $$SavedDirectoriesTableUpdateCompanionBuilder =
    SavedDirectoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> path,
      Value<String> savedAt,
      Value<String> lastModified,
    });

class $$SavedDirectoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedDirectoriesTable> {
  $$SavedDirectoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedDirectoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedDirectoriesTable> {
  $$SavedDirectoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedDirectoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedDirectoriesTable> {
  $$SavedDirectoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  GeneratedColumn<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$SavedDirectoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedDirectoriesTable,
          SavedDirectory,
          $$SavedDirectoriesTableFilterComposer,
          $$SavedDirectoriesTableOrderingComposer,
          $$SavedDirectoriesTableAnnotationComposer,
          $$SavedDirectoriesTableCreateCompanionBuilder,
          $$SavedDirectoriesTableUpdateCompanionBuilder,
          (
            SavedDirectory,
            BaseReferences<
              _$AppDatabase,
              $SavedDirectoriesTable,
              SavedDirectory
            >,
          ),
          SavedDirectory,
          PrefetchHooks Function()
        > {
  $$SavedDirectoriesTableTableManager(
    _$AppDatabase db,
    $SavedDirectoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SavedDirectoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SavedDirectoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SavedDirectoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> savedAt = const Value.absent(),
                Value<String> lastModified = const Value.absent(),
              }) => SavedDirectoriesCompanion(
                id: id,
                name: name,
                path: path,
                savedAt: savedAt,
                lastModified: lastModified,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String path,
                required String savedAt,
                required String lastModified,
              }) => SavedDirectoriesCompanion.insert(
                id: id,
                name: name,
                path: path,
                savedAt: savedAt,
                lastModified: lastModified,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedDirectoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedDirectoriesTable,
      SavedDirectory,
      $$SavedDirectoriesTableFilterComposer,
      $$SavedDirectoriesTableOrderingComposer,
      $$SavedDirectoriesTableAnnotationComposer,
      $$SavedDirectoriesTableCreateCompanionBuilder,
      $$SavedDirectoriesTableUpdateCompanionBuilder,
      (
        SavedDirectory,
        BaseReferences<_$AppDatabase, $SavedDirectoriesTable, SavedDirectory>,
      ),
      SavedDirectory,
      PrefetchHooks Function()
    >;
typedef $$GitCredentialsTableCreateCompanionBuilder =
    GitCredentialsCompanion Function({
      Value<int> id,
      required String name,
      required String token,
      Value<String?> clientId,
      Value<String?> clientSecret,
      Value<String?> apiUrl,
    });
typedef $$GitCredentialsTableUpdateCompanionBuilder =
    GitCredentialsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> token,
      Value<String?> clientId,
      Value<String?> clientSecret,
      Value<String?> apiUrl,
    });

class $$GitCredentialsTableFilterComposer
    extends Composer<_$AppDatabase, $GitCredentialsTable> {
  $$GitCredentialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientSecret => $composableBuilder(
    column: $table.clientSecret,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiUrl => $composableBuilder(
    column: $table.apiUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GitCredentialsTableOrderingComposer
    extends Composer<_$AppDatabase, $GitCredentialsTable> {
  $$GitCredentialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientSecret => $composableBuilder(
    column: $table.clientSecret,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiUrl => $composableBuilder(
    column: $table.apiUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GitCredentialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GitCredentialsTable> {
  $$GitCredentialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get clientSecret => $composableBuilder(
    column: $table.clientSecret,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apiUrl =>
      $composableBuilder(column: $table.apiUrl, builder: (column) => column);
}

class $$GitCredentialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GitCredentialsTable,
          GitCredential,
          $$GitCredentialsTableFilterComposer,
          $$GitCredentialsTableOrderingComposer,
          $$GitCredentialsTableAnnotationComposer,
          $$GitCredentialsTableCreateCompanionBuilder,
          $$GitCredentialsTableUpdateCompanionBuilder,
          (
            GitCredential,
            BaseReferences<_$AppDatabase, $GitCredentialsTable, GitCredential>,
          ),
          GitCredential,
          PrefetchHooks Function()
        > {
  $$GitCredentialsTableTableManager(
    _$AppDatabase db,
    $GitCredentialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GitCredentialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$GitCredentialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$GitCredentialsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> clientSecret = const Value.absent(),
                Value<String?> apiUrl = const Value.absent(),
              }) => GitCredentialsCompanion(
                id: id,
                name: name,
                token: token,
                clientId: clientId,
                clientSecret: clientSecret,
                apiUrl: apiUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String token,
                Value<String?> clientId = const Value.absent(),
                Value<String?> clientSecret = const Value.absent(),
                Value<String?> apiUrl = const Value.absent(),
              }) => GitCredentialsCompanion.insert(
                id: id,
                name: name,
                token: token,
                clientId: clientId,
                clientSecret: clientSecret,
                apiUrl: apiUrl,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GitCredentialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GitCredentialsTable,
      GitCredential,
      $$GitCredentialsTableFilterComposer,
      $$GitCredentialsTableOrderingComposer,
      $$GitCredentialsTableAnnotationComposer,
      $$GitCredentialsTableCreateCompanionBuilder,
      $$GitCredentialsTableUpdateCompanionBuilder,
      (
        GitCredential,
        BaseReferences<_$AppDatabase, $GitCredentialsTable, GitCredential>,
      ),
      GitCredential,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedDirectoriesTableTableManager get savedDirectories =>
      $$SavedDirectoriesTableTableManager(_db, _db.savedDirectories);
  $$GitCredentialsTableTableManager get gitCredentials =>
      $$GitCredentialsTableTableManager(_db, _db.gitCredentials);
}
