# AWS Aurora Read Replica

## Last Updated

2025-01-17

## Status

**Not Working.**

If not working:

- [ ] Error

- [x] In progress

## Description

This is an example of making an RDS DB, then creating a read replica in Aurora to migrate the RDS to Aurora.

## Quickstart

This requires Terraform and a configured AWS CLI.

1. Create **terraform.tfvars** in the **tf** directory.  It should contain the following:

    ```shell
    dbpass = "WHATEVER_PASSWORD_YOU_WANT"
    ```

    This is loaded automatically by Terraform when planned and built.

2. Create **.env** in the root directory of this toy (**aws_aurora_read_replica**) with the following content:

    ```shell
    DBPASS=WHATEVER_PASSWORD_YOU_WANT  # Must be 8 characters.
    DBHOST=  # NOTE: WILL NEED TO PUT THE HOST IN HERE LATER FROM THE OUPUT OF TF.
    DBNAME=postgres
    DBUSER=testdb
    ```

3. In the **tf** directory:

    ```shell
    terraform init
    terraform plan
    terraform apply  # Remember to copy output into the .env file above!
    ```

4. Run the **sample_data_to_rds.py** script to fill the DB.


## Migration Process



## Runbook

