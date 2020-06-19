# dataworks-development-tools

## Infrastructure for development tools

This repo contains infrastructure for development tools used by Dataworks. The infrastructure is deployed and available in `development` and `management-dev` environments only. 

## How to provision a Cloud9 IDE

As Cloud9 does not currently support `Always encrypt new EBS volumes` setting it has to be temporarily disabled while creating a Cloud9 environment for the first time.

In AWS console, 
1. Temporarily disable EBS encryption: 
    1. Navigate to EC2, click on `EC2 Dashboard` (top left) and click on `EBS Encryption` (top right);
    1. Verify that `Always encrypt new EBS volumes` setting is `Enabled`;
    1. Click `Manage`, uncheck `Always encrypt new EBS volumes` and click `Update EBS encryption`.
1. Proceed to create a Cloud9 environment as normal.
1. Re-enable `Always encrypt new EBS volumes` setting.


