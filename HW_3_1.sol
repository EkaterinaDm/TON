pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract queue_in_the_store {
    
    string[] public queue;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function get_in_line(string Name) public checkOwnerAndAccept{
        queue.push(Name);
    }

    function call_next() public checkOwnerAndAccept{
        for (uint i = 0; i < queue.length - 1; i++) {
            queue[i] = queue[i + 1];
        }
        queue.pop();
    }
}
