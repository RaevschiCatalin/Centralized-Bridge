const {ethers} = require("ethers");

const provider = new ethers.InfuraProvider("sepolia", "ba0264bd03b041038e387e3c2033c199");

const address = "0xFe2c2Ef15aA089573e1e71858cdfCF8c90291A7D"

const main = async () => {
    const balance = await provider.getBalance(address);
    console.log("Balance:", ethers.formatEther(balance));
}
main()