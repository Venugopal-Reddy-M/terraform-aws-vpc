locals {
    #common-tags
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = "true"
    }
    # vpc-tags
    vpc_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.vpc_tag
    )

    #internet-gateway-tags
    igw_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.igw_tags
    )
    
    #subnet_tags
    subnet_final_tags = merge(
    local.common_tags,
    {
        #roboshop-dev-public-us-east-la
        Name = "${var.project}-${var.environment}-public-${count.index + 1}"
    },
    var.subnet_tags
    )
}