import 'package:wts_support_engineer/model/schedule_info_model.dart';

class DashBoardInfoModel {
  int? currentSchedule;
  int? serviceProvided;
  int? schedulePending;
  int? waitingToBeComplete;
  List<ScheduleInfoModel>? scheduled;

  DashBoardInfoModel(
      {this.currentSchedule,
        this.serviceProvided,
        this.schedulePending,
        this.waitingToBeComplete,
        this.scheduled});

  DashBoardInfoModel.fromJson(Map<String, dynamic> json) {
    currentSchedule = json['current_schedule'];
    serviceProvided = json['service_provided'];
    schedulePending = json['schedule_pending'];
    waitingToBeComplete = json['waiting_to_be_complete'];
    if (json['scheduled'] != null) {
      scheduled = [];
      json['scheduled'].forEach((v) {
        scheduled?.add(new ScheduleInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_schedule'] = this.currentSchedule;
    data['service_provided'] = this.serviceProvided;
    data['schedule_pending'] = this.schedulePending;
    data['waiting_to_be_complete'] = this.waitingToBeComplete;
    if (this.scheduled != null) {
      data['scheduled'] = this.scheduled?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}