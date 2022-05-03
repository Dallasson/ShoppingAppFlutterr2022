// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Helper.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class HelperData extends DataClass implements Insertable<HelperData> {
  final int id;
  final String productImage;
  final String productTitle;
  final String productPrice;
  final String productDescription;
  final String totalPrice;
  final String totalQuantity;
  final String productId;
  final String productCategory;
  HelperData(
      {required this.id,
      required this.productImage,
      required this.productTitle,
      required this.productPrice,
      required this.productDescription,
      required this.totalPrice,
      required this.totalQuantity,
      required this.productId,
      required this.productCategory});
  factory HelperData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return HelperData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      productImage: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_image'])!,
      productTitle: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_title'])!,
      productPrice: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_price'])!,
      productDescription: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}product_description'])!,
      totalPrice: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_price'])!,
      totalQuantity: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_quantity'])!,
      productId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      productCategory: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_category'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_image'] = Variable<String>(productImage);
    map['product_title'] = Variable<String>(productTitle);
    map['product_price'] = Variable<String>(productPrice);
    map['product_description'] = Variable<String>(productDescription);
    map['total_price'] = Variable<String>(totalPrice);
    map['total_quantity'] = Variable<String>(totalQuantity);
    map['product_id'] = Variable<String>(productId);
    map['product_category'] = Variable<String>(productCategory);
    return map;
  }

  HelperCompanion toCompanion(bool nullToAbsent) {
    return HelperCompanion(
      id: Value(id),
      productImage: Value(productImage),
      productTitle: Value(productTitle),
      productPrice: Value(productPrice),
      productDescription: Value(productDescription),
      totalPrice: Value(totalPrice),
      totalQuantity: Value(totalQuantity),
      productId: Value(productId),
      productCategory: Value(productCategory),
    );
  }

  factory HelperData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HelperData(
      id: serializer.fromJson<int>(json['id']),
      productImage: serializer.fromJson<String>(json['productImage']),
      productTitle: serializer.fromJson<String>(json['productTitle']),
      productPrice: serializer.fromJson<String>(json['productPrice']),
      productDescription:
          serializer.fromJson<String>(json['productDescription']),
      totalPrice: serializer.fromJson<String>(json['totalPrice']),
      totalQuantity: serializer.fromJson<String>(json['totalQuantity']),
      productId: serializer.fromJson<String>(json['productId']),
      productCategory: serializer.fromJson<String>(json['productCategory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productImage': serializer.toJson<String>(productImage),
      'productTitle': serializer.toJson<String>(productTitle),
      'productPrice': serializer.toJson<String>(productPrice),
      'productDescription': serializer.toJson<String>(productDescription),
      'totalPrice': serializer.toJson<String>(totalPrice),
      'totalQuantity': serializer.toJson<String>(totalQuantity),
      'productId': serializer.toJson<String>(productId),
      'productCategory': serializer.toJson<String>(productCategory),
    };
  }

  HelperData copyWith(
          {int? id,
          String? productImage,
          String? productTitle,
          String? productPrice,
          String? productDescription,
          String? totalPrice,
          String? totalQuantity,
          String? productId,
          String? productCategory}) =>
      HelperData(
        id: id ?? this.id,
        productImage: productImage ?? this.productImage,
        productTitle: productTitle ?? this.productTitle,
        productPrice: productPrice ?? this.productPrice,
        productDescription: productDescription ?? this.productDescription,
        totalPrice: totalPrice ?? this.totalPrice,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        productId: productId ?? this.productId,
        productCategory: productCategory ?? this.productCategory,
      );
  @override
  String toString() {
    return (StringBuffer('HelperData(')
          ..write('id: $id, ')
          ..write('productImage: $productImage, ')
          ..write('productTitle: $productTitle, ')
          ..write('productPrice: $productPrice, ')
          ..write('productDescription: $productDescription, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('productId: $productId, ')
          ..write('productCategory: $productCategory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productImage,
      productTitle,
      productPrice,
      productDescription,
      totalPrice,
      totalQuantity,
      productId,
      productCategory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HelperData &&
          other.id == this.id &&
          other.productImage == this.productImage &&
          other.productTitle == this.productTitle &&
          other.productPrice == this.productPrice &&
          other.productDescription == this.productDescription &&
          other.totalPrice == this.totalPrice &&
          other.totalQuantity == this.totalQuantity &&
          other.productId == this.productId &&
          other.productCategory == this.productCategory);
}

class HelperCompanion extends UpdateCompanion<HelperData> {
  final Value<int> id;
  final Value<String> productImage;
  final Value<String> productTitle;
  final Value<String> productPrice;
  final Value<String> productDescription;
  final Value<String> totalPrice;
  final Value<String> totalQuantity;
  final Value<String> productId;
  final Value<String> productCategory;
  const HelperCompanion({
    this.id = const Value.absent(),
    this.productImage = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.productPrice = const Value.absent(),
    this.productDescription = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCategory = const Value.absent(),
  });
  HelperCompanion.insert({
    this.id = const Value.absent(),
    required String productImage,
    required String productTitle,
    required String productPrice,
    required String productDescription,
    required String totalPrice,
    required String totalQuantity,
    required String productId,
    required String productCategory,
  })  : productImage = Value(productImage),
        productTitle = Value(productTitle),
        productPrice = Value(productPrice),
        productDescription = Value(productDescription),
        totalPrice = Value(totalPrice),
        totalQuantity = Value(totalQuantity),
        productId = Value(productId),
        productCategory = Value(productCategory);
  static Insertable<HelperData> custom({
    Expression<int>? id,
    Expression<String>? productImage,
    Expression<String>? productTitle,
    Expression<String>? productPrice,
    Expression<String>? productDescription,
    Expression<String>? totalPrice,
    Expression<String>? totalQuantity,
    Expression<String>? productId,
    Expression<String>? productCategory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productImage != null) 'product_image': productImage,
      if (productTitle != null) 'product_title': productTitle,
      if (productPrice != null) 'product_price': productPrice,
      if (productDescription != null) 'product_description': productDescription,
      if (totalPrice != null) 'total_price': totalPrice,
      if (totalQuantity != null) 'total_quantity': totalQuantity,
      if (productId != null) 'product_id': productId,
      if (productCategory != null) 'product_category': productCategory,
    });
  }

  HelperCompanion copyWith(
      {Value<int>? id,
      Value<String>? productImage,
      Value<String>? productTitle,
      Value<String>? productPrice,
      Value<String>? productDescription,
      Value<String>? totalPrice,
      Value<String>? totalQuantity,
      Value<String>? productId,
      Value<String>? productCategory}) {
    return HelperCompanion(
      id: id ?? this.id,
      productImage: productImage ?? this.productImage,
      productTitle: productTitle ?? this.productTitle,
      productPrice: productPrice ?? this.productPrice,
      productDescription: productDescription ?? this.productDescription,
      totalPrice: totalPrice ?? this.totalPrice,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      productId: productId ?? this.productId,
      productCategory: productCategory ?? this.productCategory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productImage.present) {
      map['product_image'] = Variable<String>(productImage.value);
    }
    if (productTitle.present) {
      map['product_title'] = Variable<String>(productTitle.value);
    }
    if (productPrice.present) {
      map['product_price'] = Variable<String>(productPrice.value);
    }
    if (productDescription.present) {
      map['product_description'] = Variable<String>(productDescription.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<String>(totalPrice.value);
    }
    if (totalQuantity.present) {
      map['total_quantity'] = Variable<String>(totalQuantity.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productCategory.present) {
      map['product_category'] = Variable<String>(productCategory.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HelperCompanion(')
          ..write('id: $id, ')
          ..write('productImage: $productImage, ')
          ..write('productTitle: $productTitle, ')
          ..write('productPrice: $productPrice, ')
          ..write('productDescription: $productDescription, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('productId: $productId, ')
          ..write('productCategory: $productCategory')
          ..write(')'))
        .toString();
  }
}

class $HelperTable extends Helper with TableInfo<$HelperTable, HelperData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HelperTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _productImageMeta =
      const VerificationMeta('productImage');
  @override
  late final GeneratedColumn<String?> productImage = GeneratedColumn<String?>(
      'product_image', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _productTitleMeta =
      const VerificationMeta('productTitle');
  @override
  late final GeneratedColumn<String?> productTitle = GeneratedColumn<String?>(
      'product_title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _productPriceMeta =
      const VerificationMeta('productPrice');
  @override
  late final GeneratedColumn<String?> productPrice = GeneratedColumn<String?>(
      'product_price', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _productDescriptionMeta =
      const VerificationMeta('productDescription');
  @override
  late final GeneratedColumn<String?> productDescription =
      GeneratedColumn<String?>('product_description', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _totalPriceMeta = const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<String?> totalPrice = GeneratedColumn<String?>(
      'total_price', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _totalQuantityMeta =
      const VerificationMeta('totalQuantity');
  @override
  late final GeneratedColumn<String?> totalQuantity = GeneratedColumn<String?>(
      'total_quantity', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String?> productId = GeneratedColumn<String?>(
      'product_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _productCategoryMeta =
      const VerificationMeta('productCategory');
  @override
  late final GeneratedColumn<String?> productCategory =
      GeneratedColumn<String?>('product_category', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productImage,
        productTitle,
        productPrice,
        productDescription,
        totalPrice,
        totalQuantity,
        productId,
        productCategory
      ];
  @override
  String get aliasedName => _alias ?? 'helper';
  @override
  String get actualTableName => 'helper';
  @override
  VerificationContext validateIntegrity(Insertable<HelperData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_image')) {
      context.handle(
          _productImageMeta,
          productImage.isAcceptableOrUnknown(
              data['product_image']!, _productImageMeta));
    } else if (isInserting) {
      context.missing(_productImageMeta);
    }
    if (data.containsKey('product_title')) {
      context.handle(
          _productTitleMeta,
          productTitle.isAcceptableOrUnknown(
              data['product_title']!, _productTitleMeta));
    } else if (isInserting) {
      context.missing(_productTitleMeta);
    }
    if (data.containsKey('product_price')) {
      context.handle(
          _productPriceMeta,
          productPrice.isAcceptableOrUnknown(
              data['product_price']!, _productPriceMeta));
    } else if (isInserting) {
      context.missing(_productPriceMeta);
    }
    if (data.containsKey('product_description')) {
      context.handle(
          _productDescriptionMeta,
          productDescription.isAcceptableOrUnknown(
              data['product_description']!, _productDescriptionMeta));
    } else if (isInserting) {
      context.missing(_productDescriptionMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('total_quantity')) {
      context.handle(
          _totalQuantityMeta,
          totalQuantity.isAcceptableOrUnknown(
              data['total_quantity']!, _totalQuantityMeta));
    } else if (isInserting) {
      context.missing(_totalQuantityMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_category')) {
      context.handle(
          _productCategoryMeta,
          productCategory.isAcceptableOrUnknown(
              data['product_category']!, _productCategoryMeta));
    } else if (isInserting) {
      context.missing(_productCategoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HelperData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return HelperData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HelperTable createAlias(String alias) {
    return $HelperTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $HelperTable helper = $HelperTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [helper];
}
