require('@nomiclabs/hardhat-waffle');
import {PRIVATE_KEY, ALCHEMY_URL} from './ignore'

module.exports = {
  solidity: '0.8.1',
  networks: {
    rinkeby: {
      url: ALCHEMY_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};