module "dev_tools_vpc" {
  source                                   = "dwp/vpc/aws"
  version                                  = "3.0.8"
  vpc_name                                 = "dev-tools"
  region                                   = var.region
  vpc_cidr_block                           = local.cidr_block[local.environment]["dev-tools-vpc"]
  gateway_vpce_route_table_ids             = []
  interface_vpce_source_security_group_ids = []
  interface_vpce_subnet_ids                = aws_subnet.public.*.id
  common_tags                              = local.common_tags

  aws_vpce_services = [
    "logs",
    "monitoring",
    "ssm",
    "ssmmessages"
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.dev_tools_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = local.name })
}

resource "aws_subnet" "public" {
  count                   = local.zone_count
  cidr_block              = cidrsubnet(module.dev_tools_vpc.vpc.cidr_block, 2, count.index)
  vpc_id                  = module.dev_tools_vpc.vpc.id
  availability_zone_id    = data.aws_availability_zones.current.zone_ids[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "${local.name}-public-${local.zone_names[count.index]}" })
}

resource "aws_default_route_table" "public" {
  default_route_table_id = module.dev_tools_vpc.vpc.main_route_table_id
  tags                   = merge(local.common_tags, { Name = "${local.name}-public" })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
