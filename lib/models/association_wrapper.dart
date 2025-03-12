import 'associations.dart';

class AssociationWrapper {
  final int? index;
  final bool? isEdit;
  final bool? isScan;
  final bool? isReal;
  final Association? association;
  AssociationWrapper(
      {this.association,
      this.isReal,
      this.isEdit = false,
      this.index,
      this.isScan = false});
}
