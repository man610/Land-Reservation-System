# Blockchain-Based-Property-Registration

<a href="LICENSE"><img src="https://img.shields.io/static/v1?label=license&message=MIT&color=green"></a>
<img src="https://img.shields.io/badge/Ethereum-20232A?style=for-the-badge&logo=ethereum&logoColor=white">
<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white">
## Land Registration using Blockchain
## Problem it Solves:
1. The elimination of middlemen: The elimination of middlemen or brokers makes the process of land registration less expensive. Brokers who try to defraud uninformed people will be unable to do so any longer. Brokers frequently take a long time to finish procedures, thus our project will help people save time.
2. Provides a user-friendly interface to allow users to buy, sell, and transfer property using cryptocurrency and view the property details with transparency.
3. A distributed tamper-proof ledger that prohibits ownership fraud.
4. IPFS is used to store important property registration papers in a secure manner.

## Technology Stack:
1. Ethereum Blockchain
2. Polygon
3. Web3Dart
4. IPFS
5. Flutter
6. Metamask

## Demo
Our Dapp is demonstrated in this video [here](https://drive.google.com/file/d/1BIcbp0wF2K_gejZVfcfaC8k1YHt5OQSe/view?usp=sharing)


This is for demonstration purposes only. With this key, you can log in as Land Inspector:
 <pre><b>0xf9949ED609523b1F550094E6c19Be80e6DBE38F1</b></pre>
For user: <pre><b>0xE05820667C420aDa18225D3428666bDc5bFBd737</b></pre>\
You can also use your own Ethereum wallet key as a user.

#### Check Smart contract At Ropsten Ethereum Testnet: [here](https://rpc-mumbai.maticvigil.com/0x1f346BA99C8e428b7B0bD668114A39A15A2422A3)

There are two ways to run app on your system :
A. Using smart contract which is already deployed by us on polygon test-network. 
B. Using smart contract which will be deployed on ganache by you.

Note: For anyone of the ways, You will need to change the rpcUrl and contract address present in the 'lib/constant/constants.dart' file accordingly.

While First way i.e. using polygon test-net seem more convinient and helpful, there are not much funds present in the wallets of given (testing) accounts
For avoiding such convinience you are recommended to deploy smart contracts named as 'contracts/landcontrat.sol' using Remix IDE which is free. 

## To Run Application Locally

1. Clone the github repository and cd to the folder
2. Install the flutter, nodejs
3. Install ganache and truffle as shown below:

```
npm install -g truffle

```
4. Open Ganache and keep it running in the Background
5. Install the Metamask chrome extension, choose the local network and import the accounts
6. Compile and run our migrations from the command line as shown below:
```
truffle compile
truffle migrate
```
6 .Copy contract address as seen in the image below and paste in variable `contractAddress` located in the file `./lib/constant/constant.dart`
<pre>
2_deploy_migration.js
=====================

   Replacing 'Land'
   ----------------
   > transaction hash:    0x427b2b402f767ac6a90334ab3c687b086b274de747fe10d6e194743b15057d78
   > Blocks: 0            Seconds: 0
   <b>>contract address:    0xed690C24C60A48F8A9819c9A15AD75B70CFBEa5a</b>
   > block number:        3
   > block timestamp:     1650602828
   > account:             0x33e94e4619f0AecDf81e9676Eb82c109FBa53356
   > balance:             99.9154895
   > gas used:            3996227
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.07992454 ETH
</pre>
7. In `constant.dart` file, change the value of the variable `chainId` to `'1337'` and change the value of the variable `rpcUrl` to `"http://127.0.0.1:7545"`
8. Run the flutter web app
```
flutter pub get

flutter run -d web-server --web-port 5555
```
9. Open the browser and the dapp will be running in http://localhost:5555/
10. Create mapbox api key from https://www.mapbox.com/ and Replace it with `mapBoxApiKey`in `constant.dart` file
11. Create nftstorage api key from https://nft.storage/ and replace it.
## Project Flowchart
<img src="screenshots/flowchart.png" height="450">

## Screenshots
Home Page                   |                   Wallet connect/Login
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot1.png" height="225">  |<img src="screenshots/Screenshot7.png" height="225">

Contract Owner Dashboard               |                   User Registration
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot10.png" height="225">  |<img src="screenshots/Screenshot12.png" height="225">

Land Inspector Dashboard                   |                  User Verification 
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot11.png" height="225">     |<img src="screenshots/Screenshot5.png" height="225">

User Dashboard               |                  Adding land on Map    
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot2.png" height="225">     |<img src="screenshots/Screenshot8.png" height="225">

Land Gallery                |                   Land Details    
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot3.png" height="225">     |<img src="screenshots/Screenshot9.png" height="225">

Received Request           |                   Make Payment  
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot6.png" height="225">     |<img src="screenshots/Screenshot4.png" height="225">

Transfer ownership,Seller,buyer photo capture   |                Witness info,photo capture,transfer ownership 
:---------------------------------:        |      :------------------------------:
<img src="screenshots/Screenshot14.png" height="225">     |<img src="screenshots/Screenshot13.png" height="225">


## Members
1. [Prajyot Pawar] (https://www.linkedin.com/in/prajyot-pawar/)
2. [Prashant Nane] (https://www.linkedin.com/in/prashant-nane-8581b2179/)
3. Satish Kuchiwale
