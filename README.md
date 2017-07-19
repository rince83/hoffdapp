Hoffdapp
===========================================
Ethereum smart contract showcase.

## Docker setup:
Run ethereum testrpc:
```docker run --rm -d --name testrpc -p 8545:8545 desmart/testrpc:latest```

Run container with truffle dev framework:
```docker run -it --rm -v "${PWD}:/usr/src/app" --link testrpc -e "RPC_HOST=testrpc" --entrypoint=/bin/sh desmart/truffle:3.2```




### Compile:
in truffle docker container:
```truffle compile && truffle migrate --reset```

### Deploy to ethereum network
in truffle docker container:
```truffle migrate```

to redeploy:
```truffle migrate --reset```

### interacting with deployed smart contract
in truffle docker container: start truffle console:
```truffle console```

load instance of deployed contract:

```
var hoff;
HoffDapp.deployed().then(function(instance){hoff=instance});
```

load user accounts into variables

```
var admin = web3.eth.accounts[1]
var user = web3.eth.accounts[2]
```

add admin to contract

```hoff.addAdmin(admin)```


check if admin

```hoff.isAdmin.call(admin).then(console.log)```


add user from admin account

```hoff.addUser(user,"John Doe", {from:admin})```


get user info from contract

```hoff.getUser.call(user).then(console.log)```


add menu - called from admin account

```hoff.addMenu("id1","Burger",750, {from:admin})```


consume menu - called from user account

```hoff.consumeMenu("id1", {from:user})```
