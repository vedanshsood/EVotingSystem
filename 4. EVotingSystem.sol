// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem{

    struct vote {
        address voterAddress;
        bool choice;
    }

    struct voter {
        string voterName;
        bool voted;
    }
    
    uint256 private CountVote = 0;
    uint256 public FinalVote = 0;
    uint256 public totalvoters = 0;
    uint256 public totalvotes = 0;

    address public admin;
    string public adminName;
    string public idea;

    mapping(uint => vote) private votes;
    mapping(address => voter) public voteregister;

    enum State {Created , Voting , Ended}
    State public state;

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    modifier OnlyAdmin() {
        require(msg.sender == admin);
        _;
    }
    modifier inState( State _state) {
        require(state == _state);
        _;
    }




    constructor(
        string memory _adminName,
        string memory _idea
    ) 
    {
        admin = msg.sender;
        adminName = _adminName;
        idea = _idea;
        state = State.Created;
    }

    function addVoter(
        address voterAddress,
        string memory _voterName
    ) 
    public inState(State.Created) OnlyAdmin{
        voter memory v;
        v.voterName = _voterName ;
        v.voted = false;
        voteregister[voterAddress] = v;
        totalvoters ++;
    }

    function startVote() 
    public inState(State.Created){
        state=State.Voting;
    }
    
    function doVote (bool _choice) 
    public inState(State.Voting) returns(bool voted){
        bool isFound = false;
        if(bytes(voteregister[msg.sender].voterName).length !=0 
        && voteregister[msg.sender].voted == false){
            
            voteregister[msg.sender].voted == true;
            vote memory v;
            v.voterAddress=msg.sender;
            v.choice= _choice;
            if(_choice){
                CountVote++;
            }
            votes[totalvotes]=v;
            totalvoters++;
            isFound = true;
            
        }
        return isFound;
    }

    function endVote() public inState(State.Voting) OnlyAdmin{
        state=State.Ended;
        FinalVote = CountVote;
    }


}