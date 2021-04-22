// declaration fo solidity compiler version
pragma  solidity ^0.4.24;

contract Auction {

    address internal auction_owner;
    uint256 public auction_start;
    uint256 public auction_end;
    uint256 public highest_bid;
    address public highest_bidder;

    enum auction_state {
        CANCELLED,
        STARTED
    }

    struct item {
        string Brand;
        string Rnumber;
    }

    item public MyItem;
    address[] bidders;
    mapping(address => uint) public bids;
    auction_State public STATE;

    modifier an_ongoing_auction() {
        require(now < auction_end);
        _;
    }

    modifier only_owner() {
        require(msg.sender == auction_owner);
        _;
    }

    function bid() public payable returns (bool) {}
    function withdraw() public returns (bool) {}
    function cancel_auction() external returns (bool) {}

    event BidEvent( address indexed highestBidder, unint256 highestBid );
    event WithdrawalEvent(Address withdrawer, uint256 amount);
    event CanceledEvent(String message, uint256 time);

}
