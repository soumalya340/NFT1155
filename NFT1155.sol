// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract NFT1155 is ERC1155, Ownable {
    constructor() ERC1155("") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    event Transfer(address from, address to , uint256 id);

    struct order{
        uint256 amount;
        uint256 price;

    }

    mapping(address => uint256) public balanceRecieved;
    mapping(uint256 => order) public Orders;
    mapping(uint256 => address) Nftowner;
    mapping(address => uint256) RequestToken;


    function list(address account, uint256 _id, uint256 _amount, uint256 _price)
        public
        onlyOwner
    {
        
        Nftowner[_id] = account;
        Orders[_id].amount = _amount;
        Orders[_id].price = _price;

        _mint(account, _id, _amount, "");
    }

    function safeApprovalForNft(address account) public view onlyOwner returns(bool){
        require(balanceRecieved[account] == Orders[RequestToken[account]].price);
        return true;
    }


    function purchase(uint tokenId) external payable{
                balanceRecieved[msg.sender] = msg.value;
                RequestToken[msg.sender] = tokenId;
    }

    function Safetransfer(address _from, address _to, uint256 _tokenId) private onlyOwner {
        require(safeApprovalForNft(_to));
        Nftowner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
  }
  function withdrawMoney(address account) public onlyOwner{
        address payable to = payable(msg.sender);
        to.transfer(balanceRecieved[account]);
    }



  
}
