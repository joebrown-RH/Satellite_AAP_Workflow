# Patching

The normal patching process should be fairly simple as all of the filtering should already be in-place.

1. Publish a new version of the Content Views. This is include in [/publish/publish.yaml](/publish/publish.yaml)
2. Promote the Content View to the appropriate Lifecycle Step. This is included in [/promote_cv/promote.yaml](/promote_cv/promote.yaml). If you need to exclude/include specific content views, you can modify the filter. If you're following the structure describe in [content_views](content_views.md), you only need to promote the composite content views.
3. If you require a report of the updates that are about to be installed, you can use [/report_errata/errata_installable.yaml](/report_errata/errata_installable.yaml)
4. Once the Content View has been promoted, you can install all available updates (filtered by the Content View) using [/update_systems/update_systems.yaml](/update_systems/update_systems.yaml)
5. If you require a report showing there are no pending updates, you can run [/report_errata/errata_installable.yaml](/report_errata/errata_installable.yaml) a second time.

This process can be expanded out to include taking a snapshot before the updates are applied and running a health check after the updates are applied so the snapshot can be restored if the health check fails.

HA patching can be handled by filtering down the list of available machines. For example:
Pass 1 = `hostgroup_fullname = "General/Department1/App1/Department1-App1-Dev" and host_collection = "Patch Group 1"`
Pass 2 = `hostgroup_fullname = "General/Department1/App1/Department1-App1-Dev" and host_collection = "Patch Group 2"`
Pass 3 = `hostgroup_fullname = "General/Department1/App1/Department1-App1-Dev" and host_collection = "Patch Group 3"`
