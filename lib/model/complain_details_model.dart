
class ComplainDetailsModel {
  dynamic? invoiceNo;
  String? companyName;
  String? customerName;
  String? email;
  String? phone;
  dynamic whatsappNumber;
  String? zone;
  String? productName;
  String? productId;
  dynamic productCode;
  String? productSerialNumber;
  String? brand;
  String? model;
  dynamic voltage;
  String? warrantyPeriod;
  dynamic warrantyAvailalbe;
  dynamic serviceNote;
  dynamic installationNote;
  String? supportEngineer;
  String? assignedDate;
  String? slot;
  String? ticketStatus;
  String? completeDate;
  dynamic supportSetupNote;
  String? image;
  String? video;
  List<InstallationRequirements>? installationRequirements;
  List<dynamic>? spareParts;

  ComplainDetailsModel(
      {this.invoiceNo,
        this.companyName,
        this.customerName,
        this.email,
        this.phone,
        this.whatsappNumber,
        this.zone,
        this.productName,
        this.productId,
        this.productCode,
        this.productSerialNumber,
        this.brand,
        this.model,
        this.voltage,
        this.warrantyPeriod,
        this.warrantyAvailalbe,
        this.serviceNote,
        this.installationNote,
        this.supportEngineer,
        this.assignedDate,
        this.slot,
        this.ticketStatus,
        this.completeDate,
        this.supportSetupNote,
        this.image,
        this.video,
        this.installationRequirements,
        this.spareParts});

  ComplainDetailsModel.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['invoice_no'];
    companyName = json['company_name'];
    customerName = json['customer_name'];
    email = json['email'];
    phone = json['phone'];
    whatsappNumber = json['whatsapp_number'];
    zone = json['Zone'];
    productName = json['product_name'];
    productId = json['product_id'];
    productCode = json['product_code'];
    productSerialNumber = json['product_serial_number'];
    brand = json['brand'];
    model = json['model'];
    voltage = json['voltage'];
    warrantyPeriod = json['warranty_period'];
    warrantyAvailalbe = json['warranty_availalbe'];
    serviceNote = json['service_note'];
    installationNote = json['installation_note'];
    supportEngineer = json['support_engineer'];
    assignedDate = json['assigned_date'];
    slot = json['slot'];
    ticketStatus = json['ticket_status'];
    completeDate = json['complete_date'];
    supportSetupNote = json['support_setup_note'];
    image = json['image'];
    video = json['video'];
    if (json['installation_requirements'] != null) {
      installationRequirements = [];
      json['installation_requirements'].forEach((v) {
        installationRequirements!.add(new InstallationRequirements.fromJson(v));
      });
    }
    // if (json['spare_parts'] != null) {
    //   spareParts = [];
    //   json['spare_parts'].forEach((v) {
    //     spareParts!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_no'] = this.invoiceNo;
    data['company_name'] = this.companyName;
    data['customer_name'] = this.customerName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['whatsapp_number'] = this.whatsappNumber;
    data['Zone'] = this.zone;
    data['product_name'] = this.productName;
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['product_serial_number'] = this.productSerialNumber;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['voltage'] = this.voltage;
    data['warranty_period'] = this.warrantyPeriod;
    data['warranty_availalbe'] = this.warrantyAvailalbe;
    data['service_note'] = this.serviceNote;
    data['installation_note'] = this.installationNote;
    data['support_engineer'] = this.supportEngineer;
    data['assigned_date'] = this.assignedDate;
    data['slot'] = this.slot;
    data['ticket_status'] = this.ticketStatus;
    data['complete_date'] = this.completeDate;
    data['support_setup_note'] = this.supportSetupNote;
    data['image'] = this.image;
    data['video'] = this.video;
    if (this.installationRequirements != null) {
      data['installation_requirements'] =
          this.installationRequirements!.map((v) => v.toJson()).toList();
    }
    if (this.spareParts != null) {
      data['spare_parts'] = this.spareParts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InstallationRequirements {
  String? name;

  InstallationRequirements({this.name});

  InstallationRequirements.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

