pragma solidity ^0.4.25;


//Create factory


contract CreateVideo{
    address[] public deployedContractList;
    
    
     function Create() external{
        address newContract = new Upload();//instantiating new contract syntax
        deployedContractList.push(newContract);
    
    }
    
    
    
    
    function getDeployedContracts() external view returns(address[]){
        return deployedContractList;
    }

    
    
}

// UPLOAD factory contract section

contract Upload{
    address[] private deployedContractList;
    
    
    
    
    function CreateNewMasterBranch() external{
        address newContract = new Version(msg.sender);//instantiating new contract syntax
        deployedContractList.push(newContract);
        
    }
    
    
    function getDeployedContracts() external view returns(address[]){
        return deployedContractList;
    }

    
    
}

//main contract section
contract Version{
    
    address public owner;
    string[] private versions;
    uint version_count;
    
    
    
    struct Editor{
        address editor_address;
        bool access;
        bool editing_not_done;
        
        uint editCount;
    } 
   // struct Request
    
    
  //  event Sunidhi(address edit,uint value);
    
    
    
    address[] private editor_list;
    
    mapping(address => Editor) editor;
    
    
    
    constructor(address sender) public{
        
        owner=sender;
       
    }
    
   
    
    modifier access(address sender){
        require(editor[sender].access==true);
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
       
    
       
   function UploadVideo(string location) external onlyOwner{
       
        
        versions.push(location);
        version_count++;
       
        editor_list.push(owner);  
        editor[owner].editor_address=owner;
        editor[owner].access=true;
        editor[owner].editing_not_done=false;
       
        editor[owner].editCount++;
   }
    
   function fork() external{
       //access modifiers with timeframe:
       
        editor[msg.sender].editor_address=msg.sender;
        editor[msg.sender].access=true;
        editor[msg.sender].editing_not_done=true;
        

     
        
    }

   function MergeRequest(string location) external access(msg.sender){
        
        
        
        versions.push(location);
        version_count++;
        editor[msg.sender].editCount++;
        editor[msg.sender].editing_not_done=false;
        editor_list.push(msg.sender);
        
        //changing time back to timeframe when it can be forked
        
    }
   
   function getEditorList() external view returns(address[]){
       
       return(editor_list);
       
   }
   
   function BasicINcentiveMOdel(address candidate) external view returns(uint){
       
       return(editor[candidate].editCount);
       
   }
    
   function getLatestVersion() external view returns(string){
       
       return(versions[version_count-1]);
   }
    
    
    
    
}
