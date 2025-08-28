import 'package:flutter/material.dart';
import '../../../domain/entities/estimate_data.dart';

/// Estimate template widget for displaying professional quotation documents
class EstimateTemplateWidget extends StatelessWidget {
  final EstimateData estimateData;
  final bool isForExport;
  final Function(String field)? onFieldTap;
  final bool isKorean;

  const EstimateTemplateWidget({
    super.key,
    required this.estimateData,
    this.isForExport = false,
    this.onFieldTap,
    this.isKorean = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobileWeb = MediaQuery.of(context).size.width < 768;
    
    // Responsive sizing
    final headerHeight = isMobileWeb ? (screenHeight * 0.03).clamp(20.0, 30.0) : 50.0;
    final logoSize = isMobileWeb ? (screenWidth * 0.06).clamp(25.0, 35.0) : 60.0;
    final titleFontSize = isMobileWeb ? (screenWidth * 0.02).clamp(10.0, 14.0) : (isForExport ? 24.0 : 22.0);
    final padding = isMobileWeb ? (screenWidth * 0.01).clamp(4.0, 8.0) : 16.0;
    final sectionSpacing = isMobileWeb ? (screenHeight * 0.002).clamp(0.5, 2.0) : 8.0;
    final smallSpacing = isMobileWeb ? (screenHeight * 0.001).clamp(0.5, 1.0) : 4.0;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(headerHeight, logoSize, titleFontSize, isMobileWeb),
            _buildDivider(smallSpacing, isMobileWeb),
            _buildSupplierSection(isMobileWeb, smallSpacing, sectionSpacing),
            _buildCustomerSection(isMobileWeb, smallSpacing, sectionSpacing),
            _buildDateProjectSection(isMobileWeb, sectionSpacing),
            _buildSubmissionText(isMobileWeb, sectionSpacing),
            _buildEstimateTable(isMobileWeb),
            _buildTotalAmount(isMobileWeb, sectionSpacing, smallSpacing),
            _buildWarningText(isMobileWeb, sectionSpacing),
            _buildDisclaimerSection(isMobileWeb, sectionSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double headerHeight, double logoSize, double titleFontSize, bool isMobileWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo area
        GestureDetector(
          onTap: isForExport ? null : () => onFieldTap?.call('logo'),
          child: Container(
            width: logoSize,
            height: headerHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, color: Colors.grey[400], size: isMobileWeb ? 12 : 16),
                Text('LOGO', style: TextStyle(color: Colors.grey[400], fontSize: isMobileWeb ? 6 : 8)),
              ],
            ),
          ),
        ),
        // Title
        Text(
          isKorean ? '견적서' : 'ESTIMATE',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: isMobileWeb ? 1 : 3,
          ),
        ),
        // Estimate number
        GestureDetector(
          onTap: isForExport ? null : () => onFieldTap?.call('estimateNumber'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isMobileWeb ? 6 : 10, vertical: isMobileWeb ? 3 : 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              estimateData.estimateNumber.isEmpty 
                  ? (isKorean ? '견적번호' : 'Est. No.')
                  : estimateData.estimateNumber,
              style: TextStyle(
                fontSize: isMobileWeb ? 6 : 10,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(double smallSpacing, bool isMobileWeb) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: smallSpacing),
      height: isMobileWeb ? 1 : 2,
      color: Colors.black,
    );
  }

  Widget _buildSupplierSection(bool isMobileWeb, double smallSpacing, double sectionSpacing) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: isMobileWeb ? smallSpacing * 0.1 : smallSpacing * 0.5),
          color: Colors.grey[100],
          child: Text(
            isKorean ? '공급자 정보' : 'Supplier Information',
            style: TextStyle(
              fontSize: isMobileWeb ? 5 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: isMobileWeb ? smallSpacing * 0.1 : smallSpacing * 0.5),
        // Add supplier info fields here
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.1 : sectionSpacing * 0.6),
      ],
    );
  }

  Widget _buildCustomerSection(bool isMobileWeb, double smallSpacing, double sectionSpacing) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: isMobileWeb ? smallSpacing * 0.1 : smallSpacing * 0.5),
          color: Colors.grey[100],
          child: Text(
            isKorean ? '고객 정보' : 'Customer Information',
            style: TextStyle(
              fontSize: isMobileWeb ? 5 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: isMobileWeb ? smallSpacing * 0.1 : smallSpacing * 0.5),
        // Add customer info fields here
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.1 : sectionSpacing * 0.6),
      ],
    );
  }

  Widget _buildDateProjectSection(bool isMobileWeb, double sectionSpacing) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoField(isKorean ? '날짜' : 'DATE', estimateData.date, 'date'),
            ),
            SizedBox(width: isMobileWeb ? 3 : 20),
            Expanded(
              child: _buildInfoField(isKorean ? '프로젝트' : 'PROJECT', estimateData.projectName, 'projectName'),
            ),
          ],
        ),
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.05 : sectionSpacing * 0.6),
      ],
    );
  }

  Widget _buildSubmissionText(bool isMobileWeb, double sectionSpacing) {
    return Column(
      children: [
        Center(
          child: Text(
            isKorean ? '아래와 같이 견적을 제출합니다' : 'We hereby submit the above estimate',
            style: TextStyle(
              fontSize: isMobileWeb ? 3 : 9,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.05 : sectionSpacing * 0.6),
      ],
    );
  }

  Widget _buildEstimateTable(bool isMobileWeb) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(isKorean ? '품목' : 'Item', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text(isKorean ? '규격' : 'Spec', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text(isKorean ? '단위' : 'Unit', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text(isKorean ? '수량' : 'Qty', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text(isKorean ? '단가' : 'Unit Price', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text(isKorean ? '금액' : 'Amount', style: TextStyle(fontSize: isMobileWeb ? 4 : 8, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          // Table rows
          ...estimateData.items.map((item) => _buildTableRow(item, isMobileWeb)),
          // Empty rows if needed
          ...List.generate(5 - estimateData.items.length, (index) => _buildEmptyTableRow(isMobileWeb)),
        ],
      ),
    );
  }

  Widget _buildTableRow(EstimateItem item, bool isMobileWeb) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(item.description, style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
          Expanded(flex: 2, child: Text(item.specification, style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
          Expanded(flex: 1, child: Text(item.unit, style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
          Expanded(flex: 1, child: Text(item.quantity.toString(), style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
          Expanded(flex: 2, child: Text(item.unitPrice.toStringAsFixed(0), style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
          Expanded(flex: 2, child: Text(item.totalPrice.toStringAsFixed(0), style: TextStyle(fontSize: isMobileWeb ? 3 : 6))),
        ],
      ),
    );
  }

  Widget _buildEmptyTableRow(bool isMobileWeb) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.all(4),
      height: isMobileWeb ? 12 : 20,
      child: Row(
        children: List.generate(6, (index) => Expanded(child: Container())),
      ),
    );
  }

  Widget _buildTotalAmount(bool isMobileWeb, double sectionSpacing, double smallSpacing) {
    final totalAmount = estimateData.items.fold<double>(0, (sum, item) => sum + item.totalPrice);
    
    return Column(
      children: [
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.1 : sectionSpacing * 0.8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(isMobileWeb ? 3 : 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                color: Colors.grey[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isKorean ? '총 금액' : 'Total Amount'}: ${totalAmount.toStringAsFixed(0)} ${estimateData.amountUnit}',
                    style: TextStyle(
                      fontSize: isMobileWeb ? 4 : 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    estimateData.totalAmountText,
                    style: TextStyle(
                      fontSize: isMobileWeb ? 3 : 8,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isMobileWeb ? smallSpacing * 0.1 : smallSpacing),
      ],
    );
  }

  Widget _buildWarningText(bool isMobileWeb, double sectionSpacing) {
    return Column(
      children: [
        Center(
          child: Text(
            isKorean 
                ? '*본 견적서는 작성 시점을 기준으로 하며, 추가 옵션에 따라 달라질 수 있습니다'
                : '*This estimate is based on the time of writing and may vary depending on additional options',
            style: TextStyle(
              fontSize: isMobileWeb ? 3 : 8,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: isMobileWeb ? sectionSpacing * 0.1 : sectionSpacing * 0.3),
      ],
    );
  }

  Widget _buildDisclaimerSection(bool isMobileWeb, double sectionSpacing) {
    return Container(
      padding: EdgeInsets.all(isMobileWeb ? 2 : 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isKorean ? '중요 안내사항' : 'IMPORTANT NOTICE',
            style: TextStyle(
              fontSize: isMobileWeb ? 3 : 7,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: isMobileWeb ? 1 : 2),
          Text(
            isKorean
                ? '• 자재 비용은 공급업체나 시장 상황에 따라 달라질 수 있습니다.\n• 프로젝트에 필요한 모든 자재와 장비 사용 비용이 포함된 가격이며, 별도의 추가 비용은 청구되지 않습니다.\n• 프로젝트 진행 중 추가 작업이나 수리가 필요한 경우, 고객의 동의하에 자재비 및 인건비가 추가로 청구됩니다.'
                : '• Material costs may vary depending on suppliers or market conditions.\n• The price includes all materials and equipment usage fees required for the project. (No additional costs will be charged.)\n• If additional work or repairs are required during the project, extra material costs and labor charges will be added with customer consent.',
            style: TextStyle(
              fontSize: isMobileWeb ? 2.5 : 6,
              color: Colors.grey[700],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, String fieldKey) {
    return GestureDetector(
      onTap: isForExport ? null : () => onFieldTap?.call(fieldKey),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value.isEmpty ? label : value,
              style: TextStyle(
                fontSize: 8,
                color: value.isEmpty ? Colors.grey[400] : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}