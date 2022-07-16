pragma solidity ^0.8.1;

import "./IERC721.sol";

contract NFTStaking {
    address[] internal stakeholders;
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewards;
    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256[]) public stakedIds;

    address token;
    string public imageURI;

    constructor(address _token, string memory _imageURI) {
        token = _token;
        imageURI = _imageURI;
    }

    function getStakedIds(address staker)
        public
        view
        returns (uint256[] memory)
    {
        return stakedIds[staker];
    }

    function isStakeHolder(address _address)
        public
        view
        returns (bool, uint256)
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1) {
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    function addStakeholder(address _stakeholder) public {
        (bool _isStakeholder, ) = isStakeHolder(_stakeholder);
        if (!_isStakeholder) stakeholders.push(_stakeholder);
    }

    function removeStakeholder(address _stakeholder) private {
        (bool _isStakeholder, uint256 s) = isStakeHolder(_stakeholder);
        if (_isStakeholder) {
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    function stakeOf(address _stakeholder) public view returns (uint256) {
        return stakes[_stakeholder];
    }

    function totalStakes() public view returns (uint256) {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1) {
            _totalStakes += stakes[stakeholders[s]];
        }
        return _totalStakes;
    }

    function createStake(uint256 _tokenId) public {
        IERC721(token).transferFrom(msg.sender, address(this), _tokenId);
        ownerOf[_tokenId] = msg.sender;
        if (stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender]++;
        stakedIds[msg.sender].push(_tokenId);
    }

    function removeStake(uint256 _tokenId) public {
        require(ownerOf[_tokenId] == msg.sender);
        stakes[msg.sender]--;
        for (uint256 i = 0; i < stakedIds[msg.sender].length; i++) {
            if (stakedIds[msg.sender][i] == _tokenId) {
                stakedIds[msg.sender][i] = stakedIds[msg.sender][
                    stakedIds[msg.sender].length - 1
                ];
                stakedIds[msg.sender].pop();
            }
        }

        if (stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        IERC721(token).transferFrom(address(this), msg.sender, _tokenId);
    }

    function rewardOf(address _stakeholder) public view returns (uint256) {
        return rewards[_stakeholder];
    }

    function totalRewards() public view returns (uint256) {
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1) {
            _totalRewards += rewards[stakeholders[s]];
        }
        return _totalRewards;
    }

    function calculateReward(address _stakeholder)
        public
        view
        returns (uint256)
    {
        return stakes[_stakeholder] / 100;
    }

    function distributeRewards() public {
        for (uint256 s = 0; s < stakeholders.length; s += 1) {
            address stakeholder = stakeholders[s];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] += reward;
        }
    }

    function withdrawReward() public {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
    }
}
