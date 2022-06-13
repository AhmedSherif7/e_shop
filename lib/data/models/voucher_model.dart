import '../mappers/mapper.dart';

class VoucherModel {
  final String id;
  final String code;
  final String status;
  final double value;

  VoucherModel({
    required this.id,
    required this.code,
    required this.status,
    required this.value,
  });

  factory VoucherModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return VoucherModel(
        id: (json['id'] as String?).orEmpty(),
        code: (json['code'] as String?).orEmpty(),
        status: (json['status'] as String?).orEmpty(),
        value: ((json['value'] as num?)?.toDouble()).orEmpty(),
      );
    }
    return VoucherModel(
      id: emptyString,
      code: emptyString,
      status: emptyString,
      value: zeroDouble,
    );
  }
}
