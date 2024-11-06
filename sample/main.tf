provider "azurerm" {
  features {}

  # 비밀번호는 push 할 수 없으므로 아래 정보들은 github secret 으로 관리
}


## 리소스 그룹 함께 생성 시
resource "azurerm_resource_group" "rg" {
  name = "terraform-rg02"
  location = "Korea Central"
}

## managed_identity 생성
resource "azurerm_user_assigned_identity" "example" {
  name                = "example-identity"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #  location            = data.azurerm_resource_group.existing_rg.location
  #  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
#terraform init
#terraform plan
#terraform apply -auto-approve
#####



## 기존 리소스 그룹 참조 (삭제 시 함께 작성하면 리소스 그룹도 삭제된다.)
#data "azurerm_resource_group" "existing_rg" {
#  name = "terraform-rg02"
#}
#
### managed_identity 삭제
#resource "azurerm_user_assigned_identity" "example" {
#  name                = "example-identity"
##  location            = azurerm_resource_group.rg.location
##  resource_group_name = azurerm_resource_group.rg.name
#  location            = "Korea Central" #data.azurerm_resource_group.existing_rg.location
#  resource_group_name = "terraform-rg02" #data.azurerm_resource_group.existing_rg.name
#
#  lifecycle {
#    prevent_destroy = false
#  }
#}
#terraform init
#terraform plan -destroy -out=tfplan
#terraform apply tfplan
######

output "identity_id" {
  value = azurerm_user_assigned_identity.example.id
}
output "client_id" {
  value = azurerm_user_assigned_identity.example.client_id
}
output "principal_id" {
  value = azurerm_user_assigned_identity.example.principal_id
}

#로컬 백엔드라서 다 지워지는건지?
#destroy할 리소스를 지정하지 않아서 관련된 리소스 그룹까지 삭제?


# 각자 로컬 백엔드를 사용하면 다른 사람이 생성한 리소스 정보를 가져올 수 없으므로 import를 통해 내 로컬에 리소스 정보를 가져와야한다.
# 특정 리소스만 삭제하는 방법 확인 해야함.