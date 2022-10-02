# AWS EKS - Terraform - Flask

## Introduction
- This project will deploy AWS EKS Insfrastructure using terraform. 
- Will also create the Deployment, Services (external, LoadBalancer), Secrets in Kubernetes using yaml files and terraform.
- Can perform CRUD functions - products - after deployment.

## Step 01: AWS EKS Configuration

1. Clone the repository
```
git clone https://github.com/KenSingson/aws-eks-terraform-flask.git
```
2. Navigate to AWS_Architecture/01-ekscluster-terraform-manifests
3. Create a folder private-key, and copy the .pem file for your ec2 instance. This will be used by the BastionHost and nodegroup resources for testing to access the nodes.

![Private_KEY](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/private-key-folder.jpg)

5. Open c1-versions.tf and edit backend.
```t
backend "s3" {
    bucket = "<s3_bucket_name>"
    key = "<path/terraform.tfstate>"
    region = "<s3_bucket_region>"

    # For State Locking
    dynamodb_table = "<dynamo_table_name>"
  }
```
5. If you don't need the bastion, delete c4-02 to c4-07-* .tf files.
6. Open z-eks.auto.tfvars, and edit the values if you want to change anything.
```t
cluster_name = "flaskapp_aws"
cluster_service_ipv4_cidr = "172.20.0.0/16"
cluster_endpoint_private_access = false
cluster_endpoint_public_access = true
cluster_endpoint_public_access_cidr = [ "0.0.0.0/0" ]
cluster_version = "1.23"
```
7. If you want to change to eks_node_instance_type, declare it in the z-eks.auto.tfvars. In this example, it was set to t3.medium as the default.
```t
variable "eks_node_instance_type" {
  description = "EKS instance type"
  type = string
  default = "t3.medium"
}
```
8. You can also change the scaling_config in c5-07-eks-node-group-public.tf.
```t
scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
```
9. If everything seems good, then run terraform commands.
```t
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```
10. Alternatively, run makefile using the command:
```
make validate
make create
```
11. Verify if AWS EKS Cluster is successfully created, if you have don't have kubectl installed then follow the instructions on the [here](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html).
12. Navigate to AWS Console -> EKS

![EKS_CREATED](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/eks-cluster-created.jpg)

13. Open PowerShell or Bash, and run kubectl commands:
```
aws eks --region ap-southeast-1 update-kubeconfig --name <eks_cluster_name>
E.g.
aws eks --region ap-southeast-1 update-kubeconfig --name finance-dev-flaskapp_aws

kubectl get nodes -o wide
kubectl get svc
kubectl get pods
```

## Step 02: Kubernetes YAML files Configuration

1. Navigate to kubernetes_manifests folder
2. Edit 01-Postgresql-Namespace-Service.yaml and change externalName pointing to AWS RDS endpoint.
```t
apiVersion: v1
kind: Service
metadata:
  name: postgresql
spec:
  type: ExternalName
  externalName: <rds_endpoint>.ap-southeast-1.rds.amazonaws.com
```
3. In 02-Products-Deployment.yaml, change the env variables for username and password and retain port, db_name and db_hostname.
```t
env:
  - name: DB_USERNAME
    value: "postgres"
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: postgresql-db-password
        key: db-password
```
4. Do not change 03-Product-Service.yaml.
5. For 04-Secrets.yaml, encode the password to base64.
```t
db-password: ZGJwYXNzd29yZDEx
```
6. After, run kubectl command. To create everything.
```
kubectl apply -f .

kubectl get all
```

![apply](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/kubectl-apply-f.jpg)

![all](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/kubectl-get-all.jpg)

7. Notice for the pods, everything is running.
8. Let's try to access the product service using the NLB service. But before, navigate to EC2 > Load Balancer and ensure that the status is Active.

![nlb-status](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/nbl-status.jpg)

9. Copy the NLB DNS Name and browse, /details
```
http://a0b5a48dbd66a4468adb27550f230572-01efb4684a2a29d1.elb.ap-southeast-1.amazonaws.com**/details**
```
10. Try refreshing and notice that the pod details are changing as it matches the pods created on the EKS cluster.
11. To verify the pods, run:
```
kubectl get pods
```

## Step-03: Product CRUD API Test

1. Import the Postman collection in Postman.
2. Configure and create new environment in Postman

![postman-environment](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/postman-environment.jpg)

3. Add url in variable column and initial and current value is the NLB DNS Name.

![postman-environment-config](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/postman-environment-config.jpg)

4. In the upper-right corner, change the environment.

![postman-environment-config-change](https://github.com/KenSingson/photo_dumps/blob/main/aws-eks-terraform-flask/blob/postman-environment-config-change.jpg)

5. Trigger each API

## Step-04: Destroy YAML Resources

1. Back to kubernetes_manifests, run kubectl command to delete configurations.
```
kubectl delete -f .
```
2. Verify if pods, services and deployment were deleted.
```
kubectl get all
```

## Step-05: Convert YAML k8s files to Terraform

1. Navigate to AWS_Architecture\02-k8sresources-terraform-manifests
2. Change the c1-versions.tf pointing to the proper backend - **Step 01: AWS EKS Configuration** step 5.
3. Change the .tf files with the proper configuration just like Step-02: Kubernetes YAML files Configuration
4. If everything is all good, run terraform commands:
```t
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```
5. Then verify if NLB is already in active state, and browse \details
```
<nlb-endpoint>**/details**
```
6. Repeat **Step-03: Product CRUD API Test** for API Testing, but ensure to change the URL in the environment pointing to the new NLB created.

## Step-06: Clean up

1. First we need to destroy the services, pods and deployment.
2. Navigate to AWS_Architecture\02-k8sresources-terraform-manifests and run terraform destroy command.
```
terraform destroy -auto-approve
```
3. Navigate to AWS_Architecture/01-ekscluster-terraform-manifests and run terraform destroy command.
```
terraform destroy -auto-approve
```
4. Login to AWS Console, and double-check if everything was removed to avoid unnecessary charges.

## Thank you.
