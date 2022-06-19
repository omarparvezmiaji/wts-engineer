class ScheduleInfoModel {
  int? complainId;
  String? product;
  dynamic ticketNo;
  String? customerName;
  String? customerPhoneNumber;
  String? customerAddress;
  dynamic supportEngineer;
  dynamic assignedDate;
  dynamic slot;
  String? status;
  dynamic waitingScheduled;
  String? serviceType;
  dynamic scheduled;
  dynamic onTheWay;
  dynamic toBeCompleted;
  dynamic notCompleted;
  dynamic completed;
  dynamic productId;
  dynamic complete_date;
  dynamic warranty_period;


  bool? isBackToFollowUpLoading;
  bool? isCompletedBySuppervisorLoading;
  bool? isRescheduleLoading;
  bool? isGoingNowLoading;


  ScheduleInfoModel(
      {this.complainId,
        this.product,
        this.ticketNo,
        this.customerName,
        this.customerPhoneNumber,
        this.customerAddress,
        this.supportEngineer,
        this.assignedDate,
        this.slot,
        this.status,
        this.waitingScheduled,
        this.serviceType,
        this.scheduled,
        this.onTheWay,
        this.toBeCompleted,
        this.notCompleted,
        this.completed,
        this.productId,
        this.complete_date,
        this.warranty_period
      });

  ScheduleInfoModel.fromJson(Map<String, dynamic> json) {
    complainId = json['complain_id'];
    product = json['product'];
    ticketNo = json['ticket_no'];
    customerName = json['customer_name'];
    customerPhoneNumber = json['customer_phone_number'];
    customerAddress = json['customer_address'];
    supportEngineer = json['support_engineer'];
    assignedDate = json['assigned_date'];
    slot = json['slot'];
    status = json['status'];
    waitingScheduled = json['waiting_scheduled'];
    serviceType = json['service_type'];
    scheduled = json['scheduled'];
    onTheWay = json['on_the_way'];
    toBeCompleted = json['to_be_completed'];
    notCompleted = json['not_completed'];
    completed = json['completed'];
    productId = json['product_id'];
    complete_date = json['complete_date'];
    warranty_period = json['warranty_period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complain_id'] = this.complainId;
    data['product'] = this.product;
    data['ticket_no'] = this.ticketNo;
    data['customer_name'] = this.customerName;
    data['customer_phone_number'] = this.customerPhoneNumber;
    data['customer_address'] = this.customerAddress;
    data['support_engineer'] = this.supportEngineer;
    data['assigned_date'] = this.assignedDate;
    data['slot'] = this.slot;
    data['status'] = this.status;
    data['waiting_scheduled'] = this.waitingScheduled;
    data['service_type'] = this.serviceType;
    data['scheduled'] = this.scheduled;
    data['on_the_way'] = this.onTheWay;
    data['to_be_completed'] = this.toBeCompleted;
    data['not_completed'] = this.notCompleted;
    data['completed'] = this.completed;
    data['product_id'] = this.productId;
    return data;
  }
}