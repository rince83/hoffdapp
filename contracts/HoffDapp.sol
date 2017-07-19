pragma solidity ^0.4.4;


contract HoffDapp {

  enum UserState {ACTIVE, INACTIVE}

  struct User {
    UserState state;
    address addr;
    string name;
  }

  struct Menu {
    string id;
    string name;
    int priceInCents;
  }

  event MenuConsumed(address buyer, string menuId, int priceInCents);


  mapping(address=>bool) admins;
  mapping(address=>User) users;
  mapping(string=>address) registeredNames;
  mapping(int=>address) userAddresses;
  int userCount = 0;

  mapping(string=>Menu) menus;
  mapping(int=>string) menuIds;
  int menuCount = 0;

  mapping(address=>int) balances;

  function addAdmin(address addr) {
    admins[addr] = true;
  }

  function isAdmin(address addr) returns (bool isAdmin) {
    return admins[addr] == true;
  }

  function addUser(address addr, string name) onlyAdmin {
    require(users[addr].addr == 0);
    require(registeredNames[name] == 0);

    users[addr].addr = addr;
    users[addr].name = name;
    users[addr].state = UserState.ACTIVE;
    registeredNames[name] = addr;
    userAddresses[userCount] = addr;
    userCount++;
  }

  function deactiveUser(address addr) onlyAdmin {
    require(users[addr].addr != 0);
    users[addr].state = UserState.INACTIVE;
  }

  function getUserName(address addr) returns (string name) {
    return users[addr].name;
  }

  function userActive(address addr) returns (bool active) {
    return (users[addr].state == UserState.ACTIVE);
  }

  function getUser(address addr) returns (string name, bool active, int balance) {
    return (users[addr].name, users[addr].state==UserState.ACTIVE, balances[addr]);
  }

  function addMenu(string id, string name, int priceInCents) onlyAdmin {
    if(bytes(menus[id].id).length == 0) {
      menuIds[menuCount] = id;
      menuCount++;
    }
    menus[id].id = id;
    menus[id].name = name;
    menus[id].priceInCents = priceInCents;
  }

  function consumeMenu(string id) {
    require(users[msg.sender].state==UserState.ACTIVE);
    balances[msg.sender]+=menus[id].priceInCents;
    MenuConsumed(msg.sender, id, menus[id].priceInCents);
  }

  //=========== SECTION: Modifier ===========
  modifier onlyAdmin() {
    require(admins[msg.sender]);
    _;
  }



}
