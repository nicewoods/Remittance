var Remittance = artifacts.require("./Remittance.sol");


contract('Remittance', function(accounts) {
it("should credit account1 deposit", () => {
    var instance;
    // You *need to return* the whole Promise chain
    return Remittance.deployed()
        .then(_instance => {
          instance = _instance;
          return instance.AddCredit(0xa54bdbf7b3c6d5333d16c55cf3a5019f3ec40699b673b1cc5b345a5c06d43b90, 2, {from: accounts[1], value: web3.toWei(1,"ether")});
        })
        .then(() => {
          return instance.GetAmount.call(accounts[1]);
        })
        .then(amt => {
           assert.equal(amt.toString(10), web3.toWei(1,"ether").toString(10), "there should be exactly 1 ether on account1 at this stage")
        });
            // Do not return anything on the last callback or it will believe there is an error.
        });
  
contract('Remittance', function(accounts) {
it("should retrieve all account1 deposit", () => {
    var instance;
    // You *need to return* the whole Promise chain
    return Remittance.deployed()
        .then(_instance => {
          instance = _instance;
          var s = "0xa54bdbf7b3c6d5333d16c55cf3a5019f3ec40699b673b1cc5b345a5c06d43b90";
          return instance.AddCredit(web3.toBigNumber(s), 20, {from: accounts[1], value: web3.toWei(1,"ether")});
        })
        .then(() => {
          instance.RetrieveAmount("mydogdoesnt", "likecats",accounts[1], {from : accounts[0], gas: 1000000 }); 
        })
        .then(() => {
          return instance.GetAmount.call(accounts[1]);
        })
        .then(amt => {
           assert.equal(amt, 0, "there should be exactly 0 ether on account1 at this stage")
        });
            // Do not return anything on the last callback or it will believe there is an error.
        });
           // return instance.retrieveAmount.call("mydog", "doesntlikecats",accounts[1], {from : accounts[0]});
});});


