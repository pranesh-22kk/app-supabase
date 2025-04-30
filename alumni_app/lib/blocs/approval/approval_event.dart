abstract class ApprovalEvent {}

class LoadUnapprovedAlumni extends ApprovalEvent {}

class ApproveAlumni extends ApprovalEvent {
  final String userId;

  ApproveAlumni(this.userId);
}