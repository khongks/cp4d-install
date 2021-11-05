#!/bin/bash

echo "Create namespaces"

# The project where IBM Cloud Pak® foundational services is installed.
# IBM Cloud Pak for Data scheduling service
# IBM Cloud Pak for Data platform operator for express installation
# IBM Cloud Pak for Data service operators for express installation
oc new-project ibm-common-services

# Required for specialized installations.
# cpd-operators is the recommended name and is used in various installation commands.
oc new-project cpd-operators

# The project where the Cloud Pak for Data control plane is installed. 
# (The Cloud Pak for Data control plane is installed in a separate project from the operators.)
# If you plan to install multiple install multiple instances of Cloud Pak for Data, you must create one project for each instance.
oc new-project cpd-instance

# A few services can be installed in tethered projects. 
# A tethered project is managed by the Cloud Pak for Data control plane but is otherwise isolated from 
# Cloud Pak for Data and the other services that are installed in that project.
oc new-project cpd-instance-tether