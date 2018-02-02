pragma solidity ^0.4.0;

contract Remittance {
//0x98a85567db3806aefd03ce84271eccfed04bf1323abc6f9ee0e86230ddd543c2
    
    address owner;
 
    struct Deposit
    {
        uint amount;
        bytes32 secret;
        uint deadline;
    }    

    mapping(address => Deposit) public repository;
    uint    public limit;
 
    function Remittance(uint durationContract)
    {
        owner = msg.sender;
        limit = block.number + durationContract;
    }

    event LogNewCredit(address depositor, uint amount);
    event LogRetrievalSucceeded(address beneficiary, uint amount);
    event LogRefund(address beneficiary, uint amount);
    event LogSuicide(address beneficiary, uint amount);

    function GetAmount(address theAccount) public returns(uint)
    {
        return repository[theAccount].amount;
    }

    // owner can add credit to the contract any time
    function AddCredit(bytes32 theSecret, uint theDeadline) public payable 
    {
        if (theSecret.length == 0 || msg.value == 0)
            throw;

        if (theDeadline == 0 || theDeadline + block.number > limit)
            throw;

        Deposit storage theDeposit = repository[msg.sender];

        theDeposit.secret = theSecret;
        theDeposit.amount = msg.value;
        theDeposit.deadline = theDeadline + block.number;
        
        LogNewCredit(msg.sender, msg.value);
        // owner will maintain a list of depositors outside the contract
    }

    
    function RetrieveAmount(string password1, string password2, address depositor)
    {     
        if (repository[depositor].amount == 0 || repository[depositor].deadline < block.number)
            throw;
        
        var proof = keccak256(password1, password2);
        
        if (proof != repository[depositor].secret)
            throw;
    
        if (! msg.sender.send(repository[depositor].amount))
            throw;
        
        repository[depositor].amount = 0;
        repository[depositor].secret = 0;
        
        LogRetrievalSucceeded(msg.sender,  repository[depositor].amount);            
    }
    
    // In case the limit is reached, 
    function Refund(address depositor) public returns(bool)
    {
        if (repository[depositor].amount == 0 || repository[depositor].deadline > block.number)
            throw;

        if (! depositor.send(repository[depositor].amount)) 
            throw;

        LogRefund(depositor, repository[depositor].amount);
    }

    function suicide() public returns (bool)
    {
        selfdestruct(owner); // in case there is a self destroy owner will receive the ether 
    }    
}
