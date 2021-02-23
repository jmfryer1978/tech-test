* Building Basic Web Server Amazon Linux AMI using Packer


- Before using this tool, you need to ensure the following AWS Variables are either set as environment
  variables, or configured in your ~/.aws/credentials (Do not enter them in the Json config). 

* Assumptions Made :
- This image is being built in the eu-west-1 region (Ireland) and is using the Amazon Linux base image


Execute With :

```
packer build techtest.pkr.hcl
```
