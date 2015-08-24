resource "azure_hosted_service" "bastion" {
    name = "${var.env}-cf-bastion-service"
    location = "West Europe"
    ephemeral_contents = false
    description = "Hosted service for the CF bastion host."
    label = "${var.env}-cf-bastion-hs-01"
}

resource "azure_instance" "bastion" {
  name = "${var.env}-cf-bastion"
  hosted_service_name = "${azure_hosted_service.bastion.name}"
  image = "Ubuntu Server 14.04 LTS"
  size = "Basic_A0"
  storage_service_name = "${var.env}cfstorage"
  location = "West Europe"

  username = "${var.ssh_user}"
  ssh_key_thumbprint = "${var.ssh_key_thumbprint}"

  endpoint {
    name = "SSH"
    protocol = "tcp"
    public_port = 22
    private_port = 22
  }
}
