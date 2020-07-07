pragma solidity ^0.4.25;

//factory contract section

contract Factory{
    address[] public deployedContractList;
    
    function Upload(string location) external{
        address newContract = new Version(location,msg.sender);//instantiating new contract syntax
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
    uint endTime;
    enum Stage{ CanFork,CannotFork}
    Stage public stage=Stage.CanFork;
    
    struct Editor{ 
        address editor_address;
        bool access;
        bool editing_not_done;
        uint version_name;
    }
    
    
    
    
    
    address[] public editor_list;
    
    mapping(address => Editor) editor;
    
    
    
    constructor(string location,address sender) public{
        
        owner=sender;
        versions.push(location);
        version_count++;
       
        editor_list.push(owner);  
        editor[owner].editor_address=owner;
        editor[owner].access=true;
        editor[owner].editing_not_done=false;
        editor[owner].version_name=1;
        
    }
    
    modifier forkingTime(){
        require(stage==Stage.CanFork);
        _;
    }
    
    
    modifier waitingTime(){
        require(stage==Stage.CannotFork);
        _;
        
    }
    
   function fork() external forkingTime{
       //access modifiers with timeframe:
       
        editor[msg.sender].editor_address=msg.sender;
        editor[msg.sender].access=true;
        editor[msg.sender].editing_not_done=true;
        
        stage=Stage.CannotFork;
      //  endTime=now+20 seconds;
        //resetTimeFrame(msg.sender);
        
    }
    
    /*
    function resetTimeFrame(address forker) private {
        
        if(now>endTime)
        {
            stage=Stage.CanFork;
            editor[forker].access=false;
            
        }
        //this function is invoked when a person forks the video....once the time limit is exceeded,the video can be forked again regardless
       // of whether he or she has edited it
    }
   */
   function Update(string location) external waitingTime{
        
        
        
        versions.push(location);
        version_count++;
        editor[msg.sender].editing_not_done=false;
        editor[msg.sender].version_name=version_count;
        editor_list.push(msg.sender);
        
        //changing time back to timeframe when it can be forked
        stage=Stage.CanFork;
    }
   
   function getEditorList() external view returns(address[]){
       
       return(editor_list);
       
   }
   
   function BasicINcentiveMOdel(address candidate) external view returns(uint){
       
       return(editor[candidate].version_name);
       
   }
    
   function getLatestVersion() external view returns(string){
       
       return(versions[version_count-1]);
   }
    
    
    
    
}
