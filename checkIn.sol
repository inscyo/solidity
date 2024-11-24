// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage{
    
    struct CheckIn{
        address addr;
        uint256 timestamp;
    }

    struct Rewards{
        uint256 id;
        string name;
        uint256 needPoints;
        uint256 needItems;
    }

    struct Claimed{
        uint256 id;
        uint256 timestamp;
    }

    mapping(address => uint256) public points;
    mapping(address => uint256) public items;
    mapping(uint256 => Rewards) public reward;
    mapping(address => Claimed) public claims;

    CheckIn[] private checkin;
    Rewards[] private rewards;
    Claimed[] private claimed;

    constructor(){
        reward[1] = Rewards(1, "Poring Monster", 150, 3);
        reward[2] = Rewards(2, "Maya Monster", 450, 7);
        reward[3] = Rewards(3, "Leaf Cat Monster", 350, 4);
        reward[4] = Rewards(4, "Chimera Monster", 400, 5);
    }

    function addItems(address addr) private {
        items[addr] += 1;
    }

    function setPoints(address addr) private {
        points[addr] += 50;
        addItems(addr);
    }

    function checkIn(address addr) public {
        uint256 datetime = block.timestamp;
        CheckIn memory userAddr = CheckIn(addr, datetime);
        checkin.push(userAddr);
        setPoints(addr);
    }

    function exchange(address addr, uint256 rewardId) public {
        Rewards memory localReward = reward[rewardId];
        require(localReward.id != 0, "Reward does not exist");

        uint256 addrPoints = points[addr];
        uint256 addrItems = items[addr];
        require(addrPoints >= localReward.needPoints, "Not enough points");
        require(addrItems >= localReward.needItems, "Not enough items");

        uint256 claimTime = block.timestamp;
        Claimed memory localClaim = Claimed(rewardId, claimTime);
        claims[addr] = localClaim;
        points[addr] -= localReward.needPoints;
        items[addr] -= localReward.needItems;
    }
}