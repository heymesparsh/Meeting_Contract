// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <= 0.8.13;

// Contract to do a round table sitting arrangement for a meeting to be held.

contract Meeting {
    mapping(address => bool) private participants; // participants with a bool value
    mapping(address => uint) private positions; // positions of participants.
    address[] private addOfParticipants; // array of addresses of participants.

    uint8 private count=1;

    // function to allow members to enter.

    function participate() public{
        addOfParticipants.push(msg.sender);
        participants[msg.sender] = true;
    }
    // function to transact ethers to a destined address.
    function transact(address payable _payee) payable external{
        require(participants[_payee] == true && participants[msg.sender] == true && addOfParticipants.length >= 5 && addOfParticipants.length <= 30);
        participants[_payee] = false;
        participants[msg.sender] = false;
        positions[msg.sender] = count;
        positions[_payee] = count + 2;
        count += 4;
        for (uint8 i=0; i<addOfParticipants.length; i++) {
            if (addOfParticipants[i] == _payee || addOfParticipants[i] == msg.sender){
                addOfParticipants[i] = 0x0000000000000000000000000000000000000000;
            }
        }
        uint amount = msg.value;
        _payee.transfer(amount);
    }
    // function to set their positions according to the rules given.
    function setPositions() private{
        uint8 ref = 0;
        uint8 val = ((count+1)/2) - 1;
        require(val < addOfParticipants.length/3);
        for (uint8 i = 0; i < addOfParticipants.length; i++){
            if (addOfParticipants[i] != 0x0000000000000000000000000000000000000000 && ref < val){
                positions[addOfParticipants[i]] = 2 * (ref+1);
                ref += 1;
            }
            else if (addOfParticipants[i] != 0x0000000000000000000000000000000000000000 && ref >= val){
                positions[addOfParticipants[i]] = ref + 1;
                ref += 1;
            }
        }
    }
    // method to display their respective chair numbers.
    function showPositions(address _user) public view returns(uint){
        return positions[_user];
    }
}
