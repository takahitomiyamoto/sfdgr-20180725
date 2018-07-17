# Directory Structure
```bash
.
├── README.md
├── config
│   └── project-scratch-def.json
├── orgInit.sh
├── sfdx-project.json
└── src
    └── main
        ├── common
        │   └── classes
        │       ├── CommonConstants.cls
        │       ├── CommonConstants.cls-meta.xml
        │       ├── CommonErrorUtils.cls
        │       ├── CommonErrorUtils.cls-meta.xml
        │       ├── CommonLogger.cls
        │       └── CommonLogger.cls-meta.xml
        ├── default
        │   ├── objects
        │   │   └── User
        │   │       └── listViews
        │   │           └── AllUsers.listView-meta.xml
        │   └── profiles
        │       └── Admin.profile-meta.xml
        └── sfdgr
            ├── classes
            │   ├── AccountConstants.cls
            │   ├── AccountConstants.cls-meta.xml
            │   ├── AccountTriggerHandler.cls
            │   ├── AccountTriggerHandler.cls-meta.xml
            │   ├── AccountTriggerService.cls
            │   ├── AccountTriggerService.cls-meta.xml
            │   ├── AccountTriggerValidation.cls
            │   ├── AccountTriggerValidation.cls-meta.xml
            │   ├── BaseTriggerHandler.cls
            │   ├── BaseTriggerHandler.cls-meta.xml
            │   ├── BaseTriggerObserver.cls
            │   └── BaseTriggerObserver.cls-meta.xml
            └── triggers
                ├── AccountTrigger.trigger
                └── AccountTrigger.trigger-meta.xml
```
