pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );
    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );
    constructor() public {
        name = "Blockchain Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);
        productCount ++;
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable{
        Product memory _product = products[_id];
        address payable _seller = _product.owner;
        require(_product.id>0 && _product.id <= productCount);
        require(msg.value >= _product.price);
        require(!_product.purchased);
        require(_seller != msg.sender);
        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;
        address(_seller).transfer(msg.value);
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}
   