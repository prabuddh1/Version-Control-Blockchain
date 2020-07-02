pragma solidity ^0.4.25;

contract CampaignFactory{
    address[] public deployedCampaigns;
   
    function createCampaign(uint mini) public{
        address newCampaign = new Campaign(mini,msg.sender);//instantiating new contract syntax
        deployedCampaigns.push(newCampaign);
   
    }
    function getDeployedCampaigns() public view returns(address[]){
        return deployedCampaigns;
    }
}

contract Campaign{
   
    struct Request{
        string description;
        bool complete;
        uint value;
        address recipient;
        uint approvalCount;
        mapping(address=>bool) approvals;
       
       
    }
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address=>bool) public approvers;
    uint approversCount;
   
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
   
   
    constructor(uint minimum,address creator) public {
        manager = creator;//passing msg.sender address
        minimumContribution =minimum;
    }
   
    function contribute() public payable{
       
        require(msg.value>minimumContribution);
        approvers[msg.sender]=true;
        approversCount++;
    }
    function createRequest(string description,uint value,address recipient) public restricted{
       
       Request memory newRequest=Request({ ///memory is important cuz Rqequest is storage
          description: description,
          value : value,
          recipient : recipient,
          complete: false,
          approvalCount : 0
           
       });
       requests.push(newRequest);
       
       
       
    }
    function approveRequest(uint index) public{
        require(approvers[msg.sender]);
        require(!requests[index].approvals[msg.sender]);
       
        requests[index].approvals[msg.sender]=true;
        requests[index].approvalCount++;
    }
   
    function finalizeRequest(uint index) public restricted{
       
        require(!requests[index].complete);
   
       
        require(requests[index].approvalCount>(approversCount/2));
        requests[index].recipient.transfer(requests[index].value);
        requests[index].complete=true;
       
    }
   
}
