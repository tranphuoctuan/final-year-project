// create  ENI for Nat instance
resource "aws_network_interface" "network_interface" {
    subnet_id = aws_subnet.public_subnet[0].id
    source_dest_check = false
    
    security_groups = [aws_security_group.sg_public.id]
    tags = {
      Name = "nat_instance_network_interface"
    }
  
}
// create Elastic IP for network_interface
resource "aws_eip" "eip" {
  network_border_group = "ap-southeast-1"
  tags = {
    Name = "eip_for_network_interface"
    
  }
}
// associate eip to network_interface
resource "aws_eip_association" "ass_eip" {
  network_interface_id = aws_network_interface.network_interface.id
  allocation_id = aws_eip.eip.id
}
