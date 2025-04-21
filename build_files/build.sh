#!/bin/bash

set -ouex pipefail

# Remove fedora-release packages (with nodeps), then immeidately install the mariner replacement
# This must be a direct RPM URL because we're unable to use the azure linux repos without a valid version in os-release. It'll get updated in the next step.
rpm -ev $(rpm -qa | grep ^fedora-) --nodeps
rpm -iv https://packages.microsoft.com/yumrepos/azurelinux-3.0-prod-base-x86_64/Packages/a/azurelinux-release-3.0-25.azl3.noarch.rpm

# Install Azure Linux packages/repositories
# Note that some cannot be installed due to bzip2 versioning differences breaking bootc at this time.
dnf5 -y install \
	azurelinux-repos \
	azurelinux-repos-amd \
	azurelinux-repos-extended \
	azurelinux-repos-ms-non-oss \
	azurelinux-repos-ms-oss \
	azurelinux-repos-shared \
	azurelinux-rpm-macros \
	azurelinux-sysinfo
