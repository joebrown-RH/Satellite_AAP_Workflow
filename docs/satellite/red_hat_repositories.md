# Red Hat Repositories

This is where you can enable any Red Hat repositories you may need access to. Before you enable any repositories, please make sure that you have imported a manifest to your Satellite server and have added the appropriate subscriptions.

## RHEL Repositories
Starting with RHEL 8, the main repositories you will need to enable are `rhel-*version*-for-x86_64-baseos-rpms` and `rhel-*version*-for-x86_64-appstream-rpms` where `*version*` should be replaced with the OS version you need.

### Major releases
Most applications have their support tied to the major OS version and do not care about the minor version. As long as that is the case for your applications, you should prioritize using only the repos where `*version*` is the major OS version.

### Minor releases
If you do have applications that require a specific minor release, you will need to add the repos where `*version*` is the major and minor version. New releases of minor versions will not be automatically enabled. If you need to enable minor releases, you will need to enable future minor releases as they are released and add them to the appropriate content views.

## Satellite Client Repositories
It is recommended to enable the Satellite Client repositories as well. They are in the format `satellite-client-6-for-rhel-*version*-x86_64-rpms` and only have a version for the major OS version.