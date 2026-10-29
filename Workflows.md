## Publishing (AAP Job: Publish Content Views)
```mermaid
graph LR

Start[Start]    -->          clean_emergency[clean_emergency/clean_emergency.yaml]
clean_emergency -->|Success| publish[publish/publish.yaml]
clean_emergency -->|Failure| alert[Send Alert]
publish         -->|Success| Exit
publish         -->|Failure| alert
```

## Update Systems (AAP Job: Patch Cycle)
```mermaid
graph LR

Start[Start]   -->          promote[promote/promote.yaml]
promote        -->|Success| report_errata[report_errata/errata_installable.yaml]
promote        -->|Failure| alert[Send Alert]
report_errata  -->|Success| update_systems[update_systems/update_systems.yaml]
report_errata  -->|Failure| alert
update_systems -->|Success| report_errata2[report_errata/errata_installable.yaml]
update_systems -->|Failure| alert
report_errata2 -->|Success| Exit
report_errata2 -->|Failure| alert
```

## Emergency Publish (AAP Job: Emergency Publish)
```mermaid
graph LR

Start[Start]   -->          publish[emergency/publish.yaml]
publish        -->|Success| report_errata[report_errata/errata_installable.yaml]
publish        -->|Failure| alert[Send Alert]
report_errata  -->|Success| update_systems[update_systems/update_systems.yaml]
report_errata  -->|Failure| alert
update_systems -->|Success| report_errata2[report_errata/errata_installable.yaml]
update_systems -->|Failure| alert
report_errata2 -->|Success| Exit
report_errata2 -->|Failure| alert
```

## Automatic Emergency CVE processing (AAP Job: Process Errata)
```mermaid
graph LR

Start[Start]      -->          sync_complete[auto_emergency/check_sync_complete.yaml]
sync_complete     -->|Success| report_errata[report_errata/errata_installable.yaml]
sync_complete     -->|Failure| alert
report_errata     -->|Success| filter_errata[auto_emergency/filter_errata.yaml]
report_errata     -->|Failure| alert
filter_errata     -->|Success| publish_emergency[emergency/publish.yaml]
filter_errata     -->|Failure| alert
publish_emergency -->|Success| update_systems[update_systems/update_systems.yaml]
publish_emergency -->|Failure| alert
update_systems    -->|Success| Exit
update_systems    -->|Failure| alert
```