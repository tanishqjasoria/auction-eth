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


contract CarAuction is Auction {
    constructor(uint _bidding_time, address _owner, string _brand, string _RNumber ) {
        auction_owner = _owner;
        auction_start = block.timestamp;
        auction_end = auction_start + _bidding_time * 1 hours;
        STATE = auction_state.STARTED;
        item.Brand = _brand;
        item.Rnumber = _RNumber;
    }

    function bid() public payable an_ongoing_auction returns (bool) {
        require(bids[msg.sender] + msg.value > highest_bid, "Error: make a higher bid");
        highest_bidder = msg.sender;
        highest_bid = msg.value;
        emit BidEvent(highest_bidder, highest_bid);
        return true;
    }

    function cancel_auction() only_owner an_ongoing_auction returns (bool) {
        STATE = auction_state.CANCELLED;
        CanceledEvent("Auction Cancelled", now);
        return true;
    }

    function withdraw() public returns (bool) {
        require(now > auction_end, "ERROR: Auction still open");
        require(msg.sender != highest_bidder);
        uint amount = bids[msg.sender];
        bids[msg.sender] = 0;
        msg.sender.transfer(amount);
        WithdrawalEvent(msg.sender, amount);
        return true;
    }

    // reason for not implementing the payback function which can be run and the users are paid back
    // this can result into a lot of errors. if send and transfer fails for a particular reason, this
    // would block this function forever, as it could get stuck ever time the function is called.
    // a malicious user that bid only 1 wei from a contract with a non-payable fallback can block
    // the refund process by making the transfer method fail (and therefore throw) forever, meaning
    // that the loop will never get executed completely.


    function self_destruct() external only_owner returns (bool) {
        require(now > auction_end, "ERROR: You can destuct when the auction is running");
        for (uint i=0; i<bidders.length; i++) {
            assert(bids[bidders[i]] == 0);
        }
        selfdestruct(auction_owner);
        return true;
    }
}
