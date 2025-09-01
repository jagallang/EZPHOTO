import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../cover_page/models/cover_page_data.dart';
import '../../../core/constants/constants.dart';

/// Customer information widget for quotation template
/// 
/// This widget displays and manages customer information fields
/// in a responsive layout for the quotation template.
class CustomerInfoWidget extends StatelessWidget {
  final CoverPageData coverData;
  final Function(String fieldType, {int? textLineIndex})? onFieldTap;
  final bool isForExport;
  final bool isMobileSize;

  const CustomerInfoWidget({
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
    final verticalSpacing = isMobileSize ? 0.05 : AppDimensions.spacingXS + 2; // 모바일 앱 오버플로우 해결을 위해 더 축소
    
    return Column(
      children: [
        _buildInfoField(isKorean ? '회사명' : 'Company', 'customerCompany'),
        SizedBox(height: verticalSpacing),
        _buildInfoField(isKorean ? '주소' : 'Address', 'customerAddress'),
        SizedBox(height: verticalSpacing),
        Row(
          children: [
            Expanded(
              child: _buildInfoField(isKorean ? '전화' : 'Tel', 'customerTel'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildInfoField(isKorean ? '이메일' : 'Email', 'customerEmail'),
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
      case 'customerCompany':
        actualValue = coverData.customerCompany ?? '';
        break;
      case 'customerAddress':
        actualValue = coverData.customerAddress ?? '';
        break;
      case 'customerTel':
        actualValue = coverData.customerTel ?? '';
        break;
      case 'customerEmail':
        actualValue = coverData.customerEmail ?? '';
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