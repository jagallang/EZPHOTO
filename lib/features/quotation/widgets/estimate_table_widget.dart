import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../cover_page/models/cover_page_data.dart';
import '../../../core/constants/constants.dart';

/// Estimate table widget for quotation template
/// 
/// This widget displays and manages the estimate table
/// with responsive design for different screen sizes.
class EstimateTableWidget extends StatelessWidget {
  final CoverPageData coverData;
  final Function(String fieldType, {int? textLineIndex})? onFieldTap;
  final bool isForExport;
  final bool isA4Export;
  final bool isMobileSize;

  const EstimateTableWidget({
    super.key,
    required this.coverData,
    required this.onFieldTap,
    required this.isForExport,
    required this.isA4Export,
    required this.isMobileSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKorean = coverData.template == 'quotation_ko';
    final bool isWeb = kIsWeb;
    final int rowCount = isWeb ? 10 : 8; // 이미지와 같이 10줄
    
    return Table(
      border: TableBorder.all(color: AppColors.borderColor, width: AppDimensions.borderWidthThin),
      columnWidths: const {
        0: FlexColumnWidth(2.5), // Description
        1: FlexColumnWidth(2), // Specification  
        2: FlexColumnWidth(1), // Unit
        3: FlexColumnWidth(0.8), // Qty
        4: FlexColumnWidth(1.5), // Price
        5: FlexColumnWidth(2), // Remarks
      },
      children: [
        // 테이블 헤더
        TableRow(
          decoration: BoxDecoration(color: AppColors.grey200),
          children: [
            _buildTableHeader(isKorean ? '내용' : 'Description'),
            _buildTableHeader(isKorean ? '사양' : 'Specification'),
            _buildTableHeader(isKorean ? '단위' : 'Unit'),
            _buildTableHeader(isKorean ? '수량' : 'Qty'),
            _buildTableHeader(isKorean ? '단가' : 'Price'),
            _buildTableHeader(isKorean ? '비고' : 'Remarks'),
          ],
        ),
        // 테이블 행들
        for (int i = 0; i < rowCount; i++)
          TableRow(
            children: [
              _buildTableCell('description_$i'),
              _buildTableCell('specification_$i'),
              _buildTableCell('unit_$i'),
              _buildTableCell('qty_$i'),
              _buildTableCell('price_$i'),
              _buildTableCell('remarks_$i'),
            ],
          ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isA4Export ? AppDimensions.paddingXS + 2 : (isMobileSize ? AppDimensions.paddingXS / 2 : AppDimensions.paddingXS), // A4 수출시 패딩 줄임
        horizontal: isA4Export ? AppDimensions.paddingXS + 2 : (isMobileSize ? AppDimensions.paddingXS / 2 : AppDimensions.paddingXS - 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeSM) : (isMobileSize ? AppDimensions.fontSizeXS - 4 : AppDimensions.fontSizeXS - 2), // A4 수출 모바일웹 조건 적용
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String fieldType) {
    // 실제 데이터 가져오기
    String actualValue = coverData.tableData[fieldType] ?? '';
    
    return GestureDetector(
      onTap: isForExport ? null : () => onFieldTap?.call(fieldType),
      child: Container(
        padding: EdgeInsets.all(isA4Export ? AppDimensions.paddingXS + 2 : (isMobileSize ? AppDimensions.paddingXS / 2 : AppDimensions.paddingXS - 1)), // A4 수출시 패딩 줄임
        height: isA4Export ? AppDimensions.quotationTableCellHeight : (isMobileSize ? AppDimensions.quotationTableCellHeightMobile - 4 : AppDimensions.quotationTableCellHeightMobile), // A4 수출시 높이 줄임
        child: Text(
          actualValue.isEmpty ? '' : actualValue,
          style: TextStyle(
            fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeSM) : (isMobileSize ? AppDimensions.fontSizeXS - 4 : AppDimensions.fontSizeXS - 2), // A4 수출 모바일웹 조건 적용
            color: actualValue.isEmpty ? AppColors.textHint : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}