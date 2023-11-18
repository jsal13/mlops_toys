# Sops with AWS KMS Secrets

## Last Updated

2023-11-18

## Description

[Sops](https://github.com/mozilla/sops) is a tool one can use to encrypt files and keep in a git repository safely.

KMS is AWS's Key Management Service.

The [below section](#the-sops-process-with-aws-kms) details the general way Sops can be used to encrypt/decrypt files.  The [quickstart](#quickstart) below uses these steps.

## The Sops Process with AWS KMS

**Make sure you have created an access key in AWS and that you have configured your AWS CLI to use that access key.**

1. Create a key in AWS KMS which we will use to encrypt our local file.

2. Get the `arn` for the key in AWS KMS.

3. Use the following command:

    ```shell
    sops --kms "arn:aws:kms:the_stuff_in_the_arn_goes_here" /path/to/new/file.yaml
    ```

4. This will launch an editor.  Use YAML to creat whatever key-value pairs you'd like to encrypt.

5. Quitting out of this editor will save and encrypt the file.  You're done encrypting!

6. To decrypt, you're going to do a similar thing:

    ```shell
    sops -d --kms "arn:aws:kms:the_stuff_in_the_arn_goes_here" /path/to/new/file.enc.yaml
    ```

## Quickstart

*Note*: KMS costs a little bit of money!

1. Run `terraform init` and then `terraform plan` and `terraform apply` if things look right.  It should make an AWS KMS key.

2. Encode using the sops command in step 2 in the [Sops Process section](#the-sops-process-with-aws-kms).  This should create an encrypted yaml file.

3. Decode using the sops command above in step 5 in the [Sops Process section](#the-sops-process-with-aws-kms).  This will show the decrypted file in plain-text on the terminal.

4. Run `terraform destroy` when done with everything.
