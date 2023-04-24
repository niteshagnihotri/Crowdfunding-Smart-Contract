// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CampaignFactory{

    struct CampaignDetails{
        address campaignAddress;
        string title;
        uint requiredAmount; 
        string category;
        string description;
        string imgURI; 
        address payable owner;
        address dr_address;
        bool is_activated;
    }    

    event campaignCreated(
        address campaignAddress, string title, uint requiredAmount, string indexed category, string imgURI, 
        address indexed owner, uint timestamp, bool indexed is_activated
    );


    mapping(address => CampaignDetails) public deployedCampaigns;

    function createCampaign(
        string memory _title, uint _requiredAmount, string memory _category,
        string memory _description, string memory _imgURI ) public returns (address)
        {
            Campaign newCampaign;
            newCampaign = new Campaign(_title, _requiredAmount, _category, _description, _imgURI, msg.sender, false);
            address campaign_deployed = address(newCampaign);
            
            deployedCampaigns[campaign_deployed].campaignAddress = campaign_deployed;            
            deployedCampaigns[campaign_deployed].title = newCampaign.title();
            deployedCampaigns[campaign_deployed].requiredAmount = newCampaign.requiredAmount();
            deployedCampaigns[campaign_deployed].category = newCampaign.category();
            deployedCampaigns[campaign_deployed].description = newCampaign.description();
            deployedCampaigns[campaign_deployed].imgURI = newCampaign.imgURI();
            deployedCampaigns[campaign_deployed].owner = newCampaign.owner();
            deployedCampaigns[campaign_deployed].is_activated = newCampaign.is_activated();
            
            emit campaignCreated(campaign_deployed, _title, _requiredAmount, _category, 
            _imgURI, msg.sender, block.timestamp, false);

            return campaign_deployed;
    }

    function activateCampaign(address campaign_address, address _dr_address) public {
        deployedCampaigns[campaign_address].dr_address = _dr_address;        
        deployedCampaigns[campaign_address].is_activated = true;        
    }

}

contract Campaign{
    address public campaignAddress;
    string public title;
    uint public requiredAmount; 
    string public category;
    string public description;
    string public imgURI; 
    address payable public owner;
    bool public is_activated;
    address dr_address;
    uint public receivedAmount;

    event donated(address indexed donar, uint indexed amount, uint indexed timestamp);

    constructor(
        string memory _title,
        uint _requiredAmount, 
        string memory _category,
        string memory _description,
        string memory _imgURI, 
        address _owner,
        bool _is_activated
    ){
        title = _title;
        requiredAmount = _requiredAmount;
        category = _category;
        description = _description;
        imgURI = _imgURI;
        owner = payable(_owner);
        is_activated = _is_activated;
    }
    
    function donate() public payable{
        require(requiredAmount > receivedAmount, "Required Amount Fulfilled");
        owner.transfer(msg.value);
        receivedAmount+=msg.value;
        emit donated(msg.sender, msg.value, block.timestamp);
    }
    
}