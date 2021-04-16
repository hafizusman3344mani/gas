


class PermissionModel {
  bool canAddEmployee;
  bool canEditEmployee;
  bool canDeleteEmployee;

  bool canAddManager;
  bool canEditManager;
  bool canDeleteManager;

  bool canAddBranch;
  bool canEditBranch;
  bool canDeleteBranch;

  bool canSendNotificationToSingleUser;
  bool canSendNotificationToMultipleUser;

  Map<String, dynamic> toMap() => {
        'canAddEmployee': canAddEmployee,
        'canEditEmployee': canEditEmployee,
        'canDeleteEmployee': canDeleteEmployee,
        'canAddManager': canAddManager,
        'canEditManager': canEditManager,
        'canDeleteManager': canDeleteManager,
        'canAddBranch': canAddBranch,
        'canEditBranch': canEditBranch,
        'canDeleteBranch': canDeleteBranch,
        'canSendNotificationToSingleUser': canSendNotificationToSingleUser,
        'canSendNotificationToMultipleUser': canSendNotificationToMultipleUser
      };

  PermissionModel.fromMap(Map<String, dynamic> json)
      : canAddEmployee = json['canAddEmployee'],
        canEditEmployee = json['canEditEmployee'],
        canDeleteEmployee = json['canDeleteEmployee'],
        canAddManager = json['canAddManager'],
        canEditManager = json['canEditManager'],
        canDeleteManager = json['canDeleteManager'],
        canAddBranch = json['canAddBranch'],
        canEditBranch = json['canEditBranch'],
        canDeleteBranch = json['canDeleteBranch'],
        canSendNotificationToSingleUser =
            json['canSendNotificationToSingleUser'],
        canSendNotificationToMultipleUser =
            json['canSendNotificationToMultipleUser'];
}
