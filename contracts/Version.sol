pragma solidity ^0.4.25;

//factory contract section

/*contract Factory{
    address[] public deployedContractList;
    
    function deployContract(string location) public{
        address newContract = new Version(location,msg.sender);//instantiating new contract syntax
        deployedContractList.push(newContract);
    
    }
    function getDeployedContracts() public view returns(address[]){
        return deployedContractList;
    }
}*/

//main contract section
contract Version{
    
    address public owner;
    string[] private versions;
    uint version_count;
    string direction;
    
    struct Editor{
        address editor_address;
        bool access;
        bool editing_not_done;
        uint version_name;
    }
    
    enum Stage{ Init, Fork, Done}
    
    Stage public stage=Stage.Init;
    
    address[] public editor_list;
    
    mapping(address => Editor) editor;
    
    unit startTime;
    
    constructor(string location) public{
        
        owner=msg.sender;
        versions.push(location);
        version_count++;
       
        editor_list.push(owner);  
        editor[owner].editor_address=owner;
        editor[owner].access=true;
        editor[owner].editing_not_done=false;
        editor[owner].version_name=1;
        
    }
    
   function fork() public {
       //access modifiers with timeframe:
       
       stage= Stage.Fork;
       startTime=now;
       
       //if(now > startTime + 10 seconds)
    
        
        editor[msg.sender].editor_address=msg.sender;
        editor[msg.sender].access=true;
        editor[msg.sender].editing_not_done=true;
        
    }
   
   function update_versions(string location) public{
        
        if(stage!=Stage.Fork) { return; }
        
        
        versions.push(location);
        version_count++;
        editor[msg.sender].editing_not_done=false;
        editor[msg.sender].version_name=version_count;
        editor_list.push(msg.sender);
        
        if(now > startTime +10 seconds)
        {stage=Stage.Done; }
    }
   
   function getEditorList() public view returns(address[]){
       
       return(editor_list);
       
   }
   
   function BasicINcentiveMOdel(address candidate) public view returns(uint){
       
       return(editor[candidate].version_name);
       
   }
    
   function getLatestVersion() public view returns(string){
       
       return(versions[version_count-1]);
   }
    
    
    
    
}
