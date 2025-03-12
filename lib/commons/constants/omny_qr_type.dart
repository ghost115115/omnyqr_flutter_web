// DO NOT EDIT OR DELETE THIS FILE

import 'package:flutter/material.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/views/create_edit_qr/bloc/create_edit_qr_bloc.dart';

List<String> qrType = [
  'private',
  'business',
  'missing',
  'event',
  'emergency',
  'price',
  'assistance'
];

QrType getQrType(String value) {
  switch (value.toLowerCase()) {
    case 'private':
      return QrType.mine;
    case 'business':
      return QrType.business;
    case 'missing':
      return QrType.lost;
    case 'event':
      return QrType.going;
    case 'emergency':
      return QrType.emergency;
    case 'assistance':
      return QrType.assistance;
    case 'price':
      return QrType.price;
    default:
      return QrType.init;
  }
}

Color getQrColor(String value) {
  switch (value.toLowerCase()) {
    case 'private':
      return AppColors.mineColor;
    case 'business':
      return AppColors.businessColor;
    case 'missing':
      return AppColors.lostColor;
    case 'event':
      return AppColors.goingColor;
    case 'emergency':
      return AppColors.emergencyColor;
    case 'assistance':
      return AppColors.assistanceColor;
    case 'price':
      return AppColors.priceColor;
    default:
      return AppColors.commonBlack;
  }
}

String getQrIcon(String value) {
  switch (value.toLowerCase()) {
    case 'private':
      return AppImages.mine;
    case 'business':
      return AppImages.business;
    case 'missing':
      return AppImages.lost;
    case 'event':
      return AppImages.calendar;
    case 'emergency':
      return AppImages.car;
    case 'assistance':
      return AppImages.life;
    case 'price':
      return AppImages.fork;
    default:
      return AppImages.logo;
  }
}
