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
    string[] public versions;
    uint version_count;
    string direction;
    
    struct Editor{
        address editor_address;
        bool access;
        bool editing_not_done;
    }
    
    
    Editor[] public editor_list;
    mapping(address => Editor) editor;
    
    constructor(string location) public{
        
        owner=msg.sender;
        versions.push(location);
        version_count++;
        Editor memory newEditor=Editor({ ///memory is important cuz Rqequest is storage 
          editor_address: owner,
          access: true,
          editing_not_done:false
           
       });
       editor_list.push(newEditor);
        
    }
    
    
    

   function fork() public returns(string){
       
          Editor memory newEditor=Editor({ ///memory is important cuz Rqequest is storage 
          editor_address: msg.sender,
          access: true,
          editing_not_done:true
           
       });
       editor_list.push(newEditor);
       direction=get_version();
       return(direction);
       
   }
   function update_versions(string location) public{
        require(editor[msg.sender].access);
        versions.push(location);
        version_count++;
        editor[msg.sender].editing_not_done=false;
    }
   
    
   function get_version() public view returns(string){
       
       return(versions[version_count-1]);
   }    
}
