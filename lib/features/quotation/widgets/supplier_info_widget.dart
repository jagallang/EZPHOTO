import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../cover_page/models/cover_page_data.dart';
import '../../../core/constants/constants.dart';

/// Supplier information widget for quotation template
/// 
/// This widget displays and manages supplier information fields
/// in a responsive layout for the quotation template.
class SupplierInfoWidget extends StatelessWidget {
  final CoverPageData coverData;
  final Function(String fieldType, {int? textLineIndex})? onFieldTap;
  final bool isForExport;
  final bool isMobileSize;

  const SupplierInfoWidget({
    super.key,
    required this.coverData,
    required this.onFieldTap,
    required this.isForExport,
    required this.isMobileSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKorean = coverData.template == 'quotation_ko';
    final spacing = isMobileSize ? 1.0 : AppDimensions.spacingMD - 1; // 더 작게 축소
    final verticalSpacing = isMobileSize ? 0.05 : AppDimensions.spacingXS; // 모바일 앱 오버플로우 해결을 위해 더 축소
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoField(isKorean ? '회사명' : 'Company', 'supplierCompany'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildInfoField(isKorean ? '이메일' : 'Email', 'supplierEmail'),
            ),
          ],
        ),
        SizedBox(height: verticalSpacing),
        Row(
          children: [
            Expanded(
              child: _buildInfoField(isKorean ? '담당자' : 'Contact', 'supplierContact'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildInfoField(isKorean ? '전화' : 'Tel', 'supplierTel'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String fieldType) {
    // 실제 데이터 가져오기
    String actualValue = '';
    switch (fieldType) {
      case 'supplierCompany':
        actualValue = coverData.supplierCompany ?? '';
        break;
      case 'supplierEmail':
        actualValue = coverData.supplierEmail ?? '';
        break;
      case 'supplierContact':
        actualValue = coverData.supplierContact ?? '';
        break;
      case 'supplierTel':
        actualValue = coverData.supplierTel ?? '';
        break;
      default:
        actualValue = '';
    }
    
    return GestureDetector(
      onTap: isForExport ? null : () => onFieldTap?.call(fieldType),
      child: Container(
        height: kIsWeb ? AppDimensions.inputHeightSM / 2 : AppDimensions.inputHeightSM - 8, // 웹에서 높이 더 축소
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderColor, width: AppDimensions.borderWidthThin)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXS - 1,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                actualValue.isEmpty ? '' : actualValue,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXS - 1,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}