# MLOps Toys

A collection of MLOps Pipeline toys (templates for how to do things) for creating standard pipelines.

Most of these will be contained to a single folder.  The README in that folder will explain what the pipeline is.

## Making a New Toy

The only requirements are:

- The folder must contain a README made from `README.md.tmpl`.
- The folder must have a justfile which is run-able with `just run`.
- The folder must have one of the following (if applicable):
  - Dockerfiles or a docker-compose.yaml
  - Terraform-related files
  - Helm-related files
