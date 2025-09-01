import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../cover_page/models/cover_page_data.dart';
import '../../../core/constants/constants.dart';
import 'supplier_info_widget.dart';
import 'customer_info_widget.dart';
import 'estimate_table_widget.dart';

/// Quotation template widget for estimate generation
/// 
/// This widget handles the complex quotation template layout
/// with responsive design for both web and mobile platforms.
class QuotationTemplate extends StatelessWidget {
  final CoverPageData coverData;
  final bool isForExport;
  final Function(String fieldType, {int? textLineIndex})? onFieldTap;
  
  const QuotationTemplate({
    super.key,
    required this.coverData,
    this.isForExport = false,
    this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    // 한글/영문 버전 구분
    final bool isKorean = coverData.template == 'quotation_ko';
    
    // 화면 크기 정보 가져오기
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isMobileWeb = kIsWeb && screenWidth < AppDimensions.mobileBreakpoint;
    // 모바일 앱도 모바일 웹과 동일한 작은 폰트 크기 적용
    final isMobileSize = isMobileWeb || !kIsWeb;
    
    // A4 비율 (210:297) 고려 - 수출 모드에서는 A4에 최적화된 크기 사용
    final isA4Export = isForExport;
    
    // 수출 모드일 때는 A4 크기에 맞춘 고정 크기 사용, 그렇지 않으면 반응형 (모바일 앱 오버플로우 해결을 위해 크기 축소)
    final headerHeight = isA4Export ? AppDimensions.quotationHeaderHeight : (isMobileSize ? (screenHeight * 0.03).clamp(20.0, 30.0) : AppDimensions.quotationHeaderHeightMobile);
    final logoSize = isA4Export ? AppDimensions.coverPageLogoSize : (isMobileSize ? (screenWidth * 0.06).clamp(25.0, 35.0) : AppDimensions.coverPageLogoSizeMobile + 10);
    final titleFontSize = isA4Export ? AppDimensions.fontSizeHeading : (isMobileSize ? (screenWidth * 0.020).clamp(12.0, 16.0) : AppDimensions.fontSizeXXL);
    final padding = isA4Export ? AppDimensions.quotationPadding : (isMobileSize ? (screenWidth * 0.010).clamp(6.0, 10.0) : (isWeb ? AppDimensions.paddingLG : AppDimensions.quotationPaddingMobile));
    final sectionSpacing = isA4Export ? AppDimensions.spacingSM + 4 : (isMobileSize ? (screenHeight * 0.004).clamp(2.0, 4.0) : AppDimensions.spacingSM);
    final smallSpacing = isA4Export ? AppDimensions.spacingXS + 2 : (isMobileSize ? (screenHeight * 0.002).clamp(1.0, 2.0) : AppDimensions.spacingXS);
    
    // A4 비율 (210:297) 계산 - 수출 모드에서만 적용
    final a4Width = isA4Export ? AppDimensions.a4Width : null;
    final a4Height = isA4Export ? AppDimensions.a4Height : null;
    
    final Widget contentWidget = Container(
      width: a4Width,
      height: a4Height,
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: isA4Export ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더부 - 로고와 견적서 타이틀 (상단 공간 줄임)
          _buildQuotationHeader(
            logoSize: logoSize,
            headerHeight: headerHeight,
            titleFontSize: titleFontSize,
            isMobileSize: isMobileSize,
            isA4Export: isA4Export,
          ),
          
          // 구분선 (높이 줄임)
          Container(
            margin: EdgeInsets.symmetric(vertical: isMobileSize ? smallSpacing * 0.5 : smallSpacing),
            height: isMobileSize ? 0.5 : 2,
            color: AppColors.black,
          ),
          
          // 공급자 정보 (패딩 극도로 줄임)
          _buildSectionHeader(isKorean ? '공급업체 정보' : 'Supplier Information', isA4Export, isMobileSize, smallSpacing),
          SizedBox(height: isMobileSize ? smallSpacing * 0.05 : smallSpacing * 0.5),
          SupplierInfoWidget(
            coverData: coverData,
            onFieldTap: onFieldTap,
            isForExport: isForExport,
            isMobileSize: isMobileSize,
          ),
          SizedBox(height: isA4Export ? sectionSpacing * 0.3 : (isMobileSize ? sectionSpacing * 0.05 : sectionSpacing * 0.4)),
          
          // 고객 정보 (패딩 극도로 줄임)
          _buildSectionHeader(isKorean ? '고객 정보' : 'Customer Information', isA4Export, isMobileSize, smallSpacing),
          SizedBox(height: isMobileSize ? smallSpacing * 0.05 : smallSpacing * 0.5),
          CustomerInfoWidget(
            coverData: coverData,
            onFieldTap: onFieldTap,
            isForExport: isForExport,
            isMobileSize: isMobileSize,
          ),
          SizedBox(height: isA4Export ? sectionSpacing * 0.3 : (isMobileSize ? sectionSpacing * 0.05 : sectionSpacing * 0.4)),
          
          // 날짜와 프로젝트 (간격 극도로 줄임)
          Row(
            children: [
              _buildDateProjectField(isKorean ? '날짜' : 'DATE', '', 'date'),
              SizedBox(width: isMobileSize ? 3 : 20),
              _buildDateProjectField(isKorean ? '프로젝트' : 'PROJECT', '', 'projectName'),
            ],
          ),
          SizedBox(height: isA4Export ? sectionSpacing * 0.3 : (isMobileSize ? sectionSpacing * 0.02 : sectionSpacing * 0.4)),
          
          
          // 견적 테이블 (여기에 더 많은 공간 할당)
          EstimateTableWidget(
            coverData: coverData,
            onFieldTap: onFieldTap,
            isForExport: isForExport,
            isA4Export: isA4Export,
            isMobileSize: isMobileSize,
          ),
          SizedBox(height: isA4Export ? sectionSpacing * 0.2 : (isMobileSize ? sectionSpacing * 0.02 : sectionSpacing * 0.4)),
          
          // 총 금액
          _buildTotalAmount(isA4Export, isMobileSize, isKorean),
          SizedBox(height: isA4Export ? smallSpacing * 0.3 : (isMobileSize ? smallSpacing * 0.02 : smallSpacing * 0.6)),
          
          
          // 추가 안내 문구 (한글/영문)
          _buildImportantNotice(isA4Export, isMobileSize),
        ],
        ),
      ),
    );

    return Container(
      color: AppColors.white,
      child: contentWidget, // 스크린샷 캡처를 위해 조건부 로직 제거
    );
  }

  Widget _buildQuotationHeader({
    required double logoSize,
    required double headerHeight,
    required double titleFontSize,
    required bool isMobileSize,
    required bool isA4Export,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 좌측 로고 영역 (크기 줄임)
        GestureDetector(
          onTap: isForExport ? null : () => onFieldTap?.call('logo'),
          child: Container(
            width: logoSize,
            height: headerHeight,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
            child: coverData.logoImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                    child: Image.memory(
                      base64Decode(coverData.logoImage!),
                      fit: BoxFit.cover,
                      width: logoSize,
                      height: headerHeight,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: AppColors.textHint, size: isMobileSize ? AppDimensions.iconSM - 4 : AppDimensions.iconSM),
                      Text('LOGO', style: TextStyle(color: AppColors.textHint, fontSize: isA4Export ? AppDimensions.fontSizeXS : (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeXS - 2))),
                    ],
                  ),
          ),
        ),
        // 중앙 타이틀 (폰트 크기 조정)
        Text(
          _getTemplateTitle(),
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: isMobileSize ? (_isKoreanTemplate() ? 2 : 1) : (_isKoreanTemplate() ? 4 : 3),
          ),
        ),
        // 우측 번호 영역 (크기 줄임)
        GestureDetector(
          onTap: isForExport ? null : () => onFieldTap?.call('estNo'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isMobileSize ? AppDimensions.paddingXS + 2 : AppDimensions.paddingXS * 2.5, vertical: isMobileSize ? AppDimensions.paddingXS - 1 : AppDimensions.paddingXS + 1),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
            child: Text(
              coverData.estNo ?? _getEstNoPlaceholder(),
              style: TextStyle(
                fontSize: isA4Export ? AppDimensions.fontSizeSM : (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeXS),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getTemplateTitle() {
    switch (coverData.template) {
      case 'quotation_ko':
        return '견적서';
      case 'invoice_ko':
        return '비용 청구서';
      case 'invoice':
        return 'INVOICE';
      default:
        return 'ESTIMATE';
    }
  }

  bool _isKoreanTemplate() {
    return coverData.template == 'quotation_ko' || coverData.template == 'invoice_ko';
  }

  String _getEstNoPlaceholder() {
    switch (coverData.template) {
      case 'quotation_ko':
        return '견적번호';
      case 'invoice_ko':
        return '청구서번호';
      case 'invoice':
        return 'Invoice No.';
      default:
        return 'Est. No.';
    }
  }

  String _getNoticeTitle() {
    final isInvoice = coverData.template.contains('invoice');
    if (isInvoice) {
      final isKorean = coverData.template.contains('_ko');
      return isKorean ? '결제 안내사항' : 'PAYMENT NOTICE / 결제 안내사항';
    } else {
      return 'IMPORTANT NOTICE / 중요 안내사항';
    }
  }

  List<Widget> _buildNoticeContent(bool isA4Export, bool isMobileSize) {
    final isInvoice = coverData.template.contains('invoice');
    final fontSize = isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 3 : AppDimensions.fontSizeXS) : (isMobileSize ? AppDimensions.fontSizeXS - 5 : AppDimensions.fontSizeXS - 4);
    
    if (isInvoice && coverData.paymentNoticeLines != null) {
      // 인보이스의 경우 편집 가능한 3줄 텍스트
      return coverData.paymentNoticeLines!.asMap().entries.map((entry) {
        final index = entry.key;
        final line = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: isMobileSize ? 0.5 : 1),
          child: GestureDetector(
            onTap: isForExport ? null : () => onFieldTap?.call('paymentNotice', textLineIndex: index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: isForExport ? null : BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                line.isEmpty ? '• 결제 안내사항을 터치하여 편집' : '• $line',
                style: TextStyle(
                  fontSize: fontSize,
                  color: line.isEmpty ? AppColors.textHint : AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ),
          ),
        );
      }).toList();
    } else {
      // 견적서의 경우 기존 고정 텍스트
      return [
        Text(
          '• Material costs may vary depending on suppliers or market conditions.\n자재 비용은 공급업체나 시장 상황에 따라 달라질 수 있습니다.',
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
        SizedBox(height: isMobileSize ? 0.5 : 1),
        Text(
          '• The price includes all materials and equipment usage fees required for the project. (No additional costs will be charged.)\n프로젝트에 필요한 모든 자재와 장비 사용 비용이 포함된 가격이며, 별도의 추가 비용은 청구되지 않습니다.',
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ];
    }
  }

  List<Widget> _buildAdditionalNotice(bool isA4Export, bool isMobileSize) {
    final isInvoice = coverData.template.contains('invoice');
    
    // 인보이스의 경우 추가 안내사항 제거
    if (isInvoice) {
      return [];
    }
    
    // 견적서의 경우 기존 추가 안내사항 유지
    final fontSize = isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 3 : AppDimensions.fontSizeXS) : (isMobileSize ? AppDimensions.fontSizeXS - 5 : AppDimensions.fontSizeXS - 4);
    
    return [
      SizedBox(height: isMobileSize ? 0.5 : 1),
      Text(
        '• If additional work or repairs are required during the project, extra material costs and labor charges will be added with customer consent.\n프로젝트 진행 중 추가 작업이나 수리가 필요한 경우, 고객의 동의하에 자재비 및 인건비가 추가로 청구됩니다.',
        style: TextStyle(
          fontSize: fontSize,
          color: AppColors.textSecondary,
          height: 1.2,
        ),
      ),
    ];
  }

  Widget _buildSectionHeader(String title, bool isA4Export, bool isMobileSize, double smallSpacing) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: isMobileSize ? smallSpacing * 0.05 : smallSpacing * 0.5),
      color: AppColors.grey100,
      child: Text(
        title,
        style: TextStyle(
          fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS : AppDimensions.fontSizeMD) : (isMobileSize ? AppDimensions.fontSizeXS - 4 : AppDimensions.fontSizeMD - 3),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDateProjectField(String label, String value, String fieldType) {
    // 실제 데이터 가져오기
    String actualValue = '';
    switch (fieldType) {
      case 'date':
        actualValue = coverData.date.isNotEmpty ? coverData.date : '';
        break;
      case 'projectName':
        actualValue = coverData.projectName ?? '';
        break;
      default:
        actualValue = value;
    }
    
    return Expanded(
      child: GestureDetector(
        onTap: isForExport ? null : () => onFieldTap?.call(fieldType),
        child: Container(
          height: kIsWeb ? AppDimensions.inputHeightSM / 2 : AppDimensions.inputHeightSM - 8, // 웹에서 높이 다른 입력필드와 동일하게 축소
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderColor, width: AppDimensions.borderWidthThin)),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXS - 1,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: AppDimensions.spacingXS * 2.5),
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
      ),
    );
  }

  Widget _buildTotalAmount(bool isA4Export, bool isMobileSize, bool isKorean) {
    
    return Container(
      padding: EdgeInsets.all(isA4Export ? AppDimensions.paddingSM + 4 : (isMobileSize ? AppDimensions.paddingXS + 2 : AppDimensions.paddingSM)), // A4 수출시 패딩 줄임
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: AppDimensions.borderWidthThin),
      ),
      child: Row(
        children: [
          Text(
            isKorean ? '총 금액' : 'Total Amount',
            style: TextStyle(
              fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeSM : AppDimensions.fontSizeLG) : (isMobileSize ? AppDimensions.fontSizeXS - 1 : AppDimensions.fontSizeMD - 3), // A4 수출 모바일웹 조건 적용
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: isMobileSize ? AppDimensions.spacingSM : AppDimensions.spacingXS * 2.5), // Spacer 대신 고정 간격 사용
          Expanded(
            flex: isMobileSize ? 3 : 2, // 모바일 웹에서 입력 영역 더 넓게
            child: GestureDetector(
              onTap: isForExport ? null : () => onFieldTap?.call('totalAmount'),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobileSize ? AppDimensions.paddingXS + 2 : AppDimensions.paddingSM, 
                  vertical: isMobileSize ? AppDimensions.paddingXS / 2 : AppDimensions.paddingXS
                ), // 모바일 웹에서 패딩 축소
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300, width: AppDimensions.borderWidthThin),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                ),
                child: Text(
                  coverData.totalAmount ?? '',
                  style: TextStyle(
                    fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeMD : AppDimensions.fontSizeXL) : (isMobileSize ? AppDimensions.fontSizeXS : AppDimensions.fontSizeSM), // A4 수출 모바일웹 조건 적용
                    fontWeight: FontWeight.bold,
                    color: (coverData.totalAmount?.isEmpty ?? true) ? AppColors.textHint : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(width: isMobileSize ? AppDimensions.spacingXS + 2 : AppDimensions.spacingXS * 2.5), // 간격 축소
          Column(
            children: [
              Text(
                isKorean ? '원' : 'USD',
                style: TextStyle(
                  fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeSM) : (isMobileSize ? AppDimensions.fontSizeXS - 4 : AppDimensions.fontSizeXS - 2), // A4 수출 모바일웹 조건 적용
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: isForExport ? null : () => onFieldTap?.call('taxIncluded'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey400, width: 1),
                            borderRadius: BorderRadius.circular(3),
                            color: (coverData.taxIncluded == true) ? AppColors.primaryBlue : Colors.transparent,
                          ),
                          child: (coverData.taxIncluded == true) 
                              ? Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                        SizedBox(width: 4),
                        Text(
                          isKorean ? '세금포함' : 'Tax included',
                          style: TextStyle(
                            fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 3 : AppDimensions.fontSizeXS - 1) : (isMobileSize ? AppDimensions.fontSizeXS - 5 : AppDimensions.fontSizeXS - 3),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: isForExport ? null : () => onFieldTap?.call('taxExcluded'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey400, width: 1),
                            borderRadius: BorderRadius.circular(3),
                            color: (coverData.taxIncluded == false) ? AppColors.primaryBlue : Colors.transparent,
                          ),
                          child: (coverData.taxIncluded == false) 
                              ? Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                        SizedBox(width: 4),
                        Text(
                          isKorean ? '세금미포함' : 'Tax excluded',
                          style: TextStyle(
                            fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 3 : AppDimensions.fontSizeXS - 1) : (isMobileSize ? AppDimensions.fontSizeXS - 5 : AppDimensions.fontSizeXS - 3),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotice(bool isA4Export, bool isMobileSize) {
    return Container(
      padding: EdgeInsets.all(isA4Export ? AppDimensions.paddingSM + 4 : (isMobileSize ? AppDimensions.paddingXS / 2 : AppDimensions.paddingXS + 2)),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border.all(color: AppColors.grey300, width: AppDimensions.borderWidthThin),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXS + 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getNoticeTitle(),
            style: TextStyle(
              fontSize: isA4Export ? (isMobileSize ? AppDimensions.fontSizeXS - 2 : AppDimensions.fontSizeSM) : (isMobileSize ? AppDimensions.fontSizeXS - 4 : AppDimensions.fontSizeXS - 1),
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: isMobileSize ? 1 : 2),
          ..._buildNoticeContent(isA4Export, isMobileSize),
          ..._buildAdditionalNotice(isA4Export, isMobileSize),
        ],
      ),
    );
  }
}