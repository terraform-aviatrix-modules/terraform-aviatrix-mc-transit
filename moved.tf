#Moved VPC resource in version 2.5.2 because of conditionality
moved {
  from = aviatrix_vpc.default
  to   = aviatrix_vpc.default[0]
}
