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
  final String disclaimerText;
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
    this.disclaimerText = '''* 자재 비용은 공급업체나 시장 상황에 따라 달라질 수 있습니다.
* 프로젝트에 필요한 모든 자재와 장비 사용 비용이 포함된 가격이며, 별도의 추가 비용은 청구되지 않습니다.
* 프로젝트 진행 중 추가 작업이나 수리가 필요한 경우, 고객의 동의하에 자재비 및 인건비가 추가로 청구됩니다.''',
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
    String? disclaimerText,
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
      disclaimerText: disclaimerText ?? this.disclaimerText,
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