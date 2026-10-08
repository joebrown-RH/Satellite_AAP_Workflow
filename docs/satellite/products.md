# Products

This is where you can add any 3rd party repositories or create your own.

When adding new products, you do not need to create a product entry for each OS version. Instead, you should create a single product entry for the general repo name and then create seperate repositories within that product entry for each OS version. 

## Restrict to OS
When configuring the repository, there are some options for `Restrict to Architecture` and `Restrict to OS version`. It is highly recommended to enable these options. They will allow `subscription-manager` to automatically filter out any repositories that are not relevant to the OS that is running.

## Download Policy
For Red Hat repositories, the default download policy is `On Demand`. This means that only the repodata will be downloaded during the sync and any rpm files that are required will be downloaded upon request. For 3rd party repositories, it is recommended to set it to `Immediate` instead. `Immediate` will download all of the rpm files during the sync process in addition to the repodata. This is recommended because some 3rd party repositories will remove old rpm files as new versions are released. When you are directly attached to those 3rd part repositories, that is not normally an issue. However, since Satellite content views allow you to freeze the repository on a specific date, your published repodata may not always reference the latest package version. This can result in a client requesting a version of a package that is no longer available unless the Satellite server has already cached the rpm file. `Immediate` will cause the Satellite server to cache everything as part of the sync process and removes the dependency for the 3rd party repository to keep old versions of packages.

## GPG Keys and Client Certificates
GPG Keys and Client Certificates are defined in `Content Credentials`. Each GPG Key and Client Certificate will get their own entry.

GPG Keys are used to verify the repodata or package was signed by the upstream repository.

Client Certificates are used to allow the Satellite server to access secure repositories.

## Repositories without an upstream
If a product supplies you with an rpm but without an upstream repository, you can create a repository entry in Satellite without defining an upstream. This will allow you to upload the rpm files directly to the Satellite server so it can make it available to all of your systems. It is still recommended to restrict the repository to specific OS versions and architectures if the rpm is built for a specific OS version or architecture.

## Example - EPEL
Content Credential 1:
```
Name: EPEL_9:
Type: GPG Key
Content: *content of https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-9*
```
Content Credential 2:
```
Name: EPEL_10:
Type: GPG Key
Content: *content of https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-10*
```

Product:
```
Name: EPEL
```
Repository 1:
```
Name: EPEL_9
Type: yum
Restrict to Architecture: x86_64
Restrict to OS version: Red Hat Enterprise Linux 9
Upstream URL: https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/
Download Policy: Immediate
GPG Key: EPEL_9
```
Repository 2:
```
Name: EPEL_10
Type: yum
Restrict to Architecture: x86_64
Restrict to OS version: Red Hat Enterprise Linux 10
Upstream URL: https://dl.fedoraproject.org/pub/epel/10/Everything/x86_64/
Download Policy: Immediate
GPG Key: EPEL_10
```