pragma solidity ^0.4.4;


contract HoffDapp {

  enum UserState {ACTIVE, INACTIVE}

  struct User {
    UserState state;
    address addr;
    string name;
  }

  mapping(address=>bool) public admins;
  mapping(address=>User) public users;
  mapping(string=>address) registeredNames;


  function addAdmin(address addr) {
    admins[addr] = true;
  }
  function isAdmin(address addr) returns (bool isAdmin) {
    return admins[addr] == true;
  }

  function register(string name) {
    require(users[msg.sender].addr == 0);
    require(registeredNames[name] == 0);

    users[msg.sender].addr = msg.sender;
    users[msg.sender].name = name;
    users[msg.sender].state = UserState.INACTIVE;
    registeredNames[name] = msg.sender;
  }


  function activateUser(address addr) onlyAdmin {
    require(users[addr].addr != 0);
    require(users[addr].state == UserState.INACTIVE);

    users[addr].state = UserState.ACTIVE;
  }

  function getUserName(address addr) returns (string name) {
    return users[addr].name;
  }

  function userActive(address addr) returns (bool active) {
    return (users[addr].state == UserState.ACTIVE);
  }

  //function getUser(address addr) returns (String name, UserState state) {
  //  return users[addr].name, users[addr].state);
  //}


  //=========== SECTION: Modifier ===========
  modifier onlyAdmin() {
    require(admins[msg.sender]);
    _;
  }

}
