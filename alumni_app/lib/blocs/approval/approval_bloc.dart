import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_app/services/supabase_service.dart';
import 'approval_event.dart';
import 'approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final SupabaseService supabaseService;

  ApprovalBloc(this.supabaseService) : super(ApprovalInitial()) {
    on<LoadUnapprovedAlumni>(_onLoadUnapprovedAlumni);
    on<ApproveAlumni>(_onApproveAlumni);
  }

  Future<void> _onLoadUnapprovedAlumni(
      LoadUnapprovedAlumni event, Emitter<ApprovalState> emit) async {
    emit(ApprovalLoading());
    try {
      final alumni = await supabaseService.getUnapprovedAlumni();
      emit(ApprovalLoaded(alumni));
    } catch (e) {
      emit(ApprovalError(e.toString()));
    }
  }

  Future<void> _onApproveAlumni(
      ApproveAlumni event, Emitter<ApprovalState> emit) async {
    try {
      await supabaseService.approveAlumni(event.userId);
      final alumni = await supabaseService.getUnapprovedAlumni();
      emit(ApprovalLoaded(alumni));
    } catch (e) {
      emit(ApprovalError(e.toString()));
    }
  }
}