/// Estimate-specific data for the estimate cover template
class EstimateData {
  final String toCompany;
  final String toAddress;
  final String toTel;
  final String toFax;
  final String date;
  final String projectName;
  final String amount;
  final String amountUnit;
  final String totalAmountText;
  final String footerNote;
  final String estimateNumber;
  final List<EstimateItem> items;

  EstimateData({
    this.toCompany = '',
    this.toAddress = '',
    this.toTel = '',
    this.toFax = '',
    this.date = '',
    this.projectName = '',
    this.amount = '',
    this.amountUnit = '원',
    this.totalAmountText = '(부가세별도)',
    this.footerNote = '이상과 같이 견적을 제출합니다',
    this.estimateNumber = '',
    this.items = const [],
  });

  EstimateData copyWith({
    String? toCompany,
    String? toAddress,
    String? toTel,
    String? toFax,
    String? date,
    String? projectName,
    String? amount,
    String? amountUnit,
    String? totalAmountText,
    String? footerNote,
    String? estimateNumber,
    List<EstimateItem>? items,
  }) {
    return EstimateData(
      toCompany: toCompany ?? this.toCompany,
      toAddress: toAddress ?? this.toAddress,
      toTel: toTel ?? this.toTel,
      toFax: toFax ?? this.toFax,
      date: date ?? this.date,
      projectName: projectName ?? this.projectName,
      amount: amount ?? this.amount,
      amountUnit: amountUnit ?? this.amountUnit,
      totalAmountText: totalAmountText ?? this.totalAmountText,
      footerNote: footerNote ?? this.footerNote,
      estimateNumber: estimateNumber ?? this.estimateNumber,
      items: items ?? this.items,
    );
  }
}

/// Individual item in the estimate
class EstimateItem {
  final String description;
  final String specification;
  final String unit;
  final int quantity;
  final double unitPrice;
  final String remarks;

  EstimateItem({
    this.description = '',
    this.specification = '',
    this.unit = '',
    this.quantity = 1,
    this.unitPrice = 0.0,
    this.remarks = '',
  });

  double get totalPrice => quantity * unitPrice;

  EstimateItem copyWith({
    String? description,
    String? specification,
    String? unit,
    int? quantity,
    double? unitPrice,
    String? remarks,
  }) {
    return EstimateItem(
      description: description ?? this.description,
      specification: specification ?? this.specification,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      remarks: remarks ?? this.remarks,
    );
  }
}