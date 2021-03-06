pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task_list {
    struct Task {
        string title;
        uint32 time;
        bool flag;          
    }
    uint8 public key = 0;
    mapping(uint8 => Task) public assocArray;

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

    function add_task(string title) public checkOwnerAndAccept{
        Task task = Task(title, now, false);
        assocArray[key] = task; 
        key += 1;  
    }

    function get_number_of_open_tasks() public checkOwnerAndAccept returns (uint32 task_kolvo) {
        uint32 kolvo = 0;
        for (uint8 i=0; i<key; i++) {
            if (assocArray[i].flag == false && assocArray[i].title != ""){
                kolvo +=1;
            }
        } 
        return (kolvo);
        kolvo = 0;
    }
    
    function get_task_list() public checkOwnerAndAccept returns (string[] tasks){
        string[] mas;
        for (uint8 i=0; i<key; i++) {
            if (assocArray[i].title != ""){
                mas.push(assocArray[i].title);
            }
        } 
        return mas;
        delete mas;
    }

    function get_task_description(uint8 number) public checkOwnerAndAccept view returns (Task task) {
        return assocArray[number];
    }

    function delete_task(uint8 number) public checkOwnerAndAccept{
        delete assocArray[number];
    }

    function mark_task_completed(uint8 number) public checkOwnerAndAccept{
        assocArray[number].flag = true;
    }
}
