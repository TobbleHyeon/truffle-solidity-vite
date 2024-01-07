// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0 <0.8.18;

contract RWD {
    string public name = 'Reward Token';
    string public symbol = 'RWD';
    uint256 public totalSupply = 1000000000000000000;
    uint8 public decimals = 18;

    // 토큰 전송 이벤트 (발신자, 수신자, 수량)
    event Transfer (
        address indexed _from, 
        address indexed _to, 
        uint _value
    );

    // 토큰 이동 권한 부여 이벤트
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint _value
    );

    // 각 월렛의 잔액 추적 목적 맵핑
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    // 수신자 주소와 수량
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        // 메세지 발신자 잔액에서 전송하는 값을 빼 줌.

        balanceOf[_to] += _value;
        // 수신자에게는 전송하는 값을 더해 줌.
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // 3자 관점에서 보는 함수라고 생각.
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_to] += _value;
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

}