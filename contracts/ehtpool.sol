// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ETHPool {

    mapping(address => bool) public team_members;
    uint256 internal rewards;
    address internal contract_admin;
    uint256 internal claimable_pool;
    uint256 public total_pool;
    uint256 public rewards_timestamp;
    uint256 public claimable_rewards;
    
    struct User_Transactions {
        uint256 amount;
        uint256 deposit_timestamp;
    }

    mapping(address => User_Transactions[]) internal deposits;

    constructor() {

        contract_admin = msg.sender;
    }

    function update_team(address member_address, bool is_allowed) public {

        require(msg.sender == contract_admin, "Function only callable by contract admin.");
        team_members[member_address] = is_allowed;
    }

    function deposit_rewards() public payable {

        require(team_members[msg.sender] == true, "Only team members are allowed to deposit rewards");
        rewards += msg.value;
        claimable_rewards += msg.value;
        rewards_timestamp = block.timestamp; 
        claimable_pool = total_pool;
    }

    function user_deposit() public payable {

        deposits[msg.sender].push(User_Transactions(msg.value, block.timestamp));
        total_pool += msg.value;
    }

    function withdraw() public {

        require(deposits[msg.sender].length > 0, "You have no deposits on your behalf.");
        uint256 added_before_rewards;
        uint256 added_to_pool;

        for (uint i=0; i < deposits[msg.sender].length; i++) {
            if (deposits[msg.sender][i].deposit_timestamp < rewards_timestamp) {
                added_before_rewards += deposits[msg.sender][i].amount;                
            }
            added_to_pool += deposits[msg.sender][i].amount;
        }  
            
        uint256 share_of_pool = (added_before_rewards * 100) / claimable_pool;
        uint256 withdrawal_amount = added_to_pool + (rewards / 100) * share_of_pool;
        (bool success, ) = msg.sender.call{value: withdrawal_amount}("");
        require(success, "Transfer failed.");

        claimable_rewards -= (rewards / 100) * share_of_pool;
        total_pool -= added_to_pool;
        delete deposits[msg.sender];
         
    } 

    function contract_balance() public view returns(uint256) {
        return address(this).balance;
    }
}