# TinySender Smart Contract

## 📌 Overview

**TinySender** is a lightweight, gas-optimized smart contract designed to send a fixed amount of ETH (**0.0001 ETH**) from one wallet to another.

The contract does **not store funds**. Instead, it acts as a **relay**, forwarding ETH sent during a transaction directly to the recipient.

---

## 🌐 Deployed Contract (Base Sepolia)

* **Contract Address:**
  `0xa15618b00619a8b1291b40115c7dCf3Bd119FC86`

* **Block Explorer:**
  https://sepolia.basescan.org/address/0xa15618b00619a8b1291b40115c7dcf3bd119fc86

---

## ⚙️ Features

* Send exactly **0.0001 ETH**
* Accepts extra ETH and refunds automatically
* Emits events for tracking (frontend + backend)
* Fully gas-optimized
* No fund storage (safer design)

---

## 🧪 Test Coverage

This contract has been tested using **Foundry** with **100% test coverage**.

### ✅ What is Covered

* Successful ETH transfer
* Refund of excess ETH
* Revert on insufficient ETH
* Event emission
* Transfer failure scenarios

 check (/coveragetest.png)
```

---

## 🧾 Core Function

```solidity
function sendTinyETH(address payable recipient) external payable;
```

### Behavior

* Requires at least `0.0001 ETH`
* Sends `0.0001 ETH` to recipient
* Refunds excess ETH
* Emits `TinySent` event

---

## 📡 Event

```solidity
event TinySent(address indexed from, address indexed to, uint256 amount);
```

---

## 🧠 How It Works

1. User calls function
2. User attaches ETH (`msg.value`)
3. Contract:

   * Sends fixed amount
   * Refunds extra
4. Event is emitted for tracking

---

## 💰 Interacting via Remix

### Value (Wei)

```
100000000000000
```

### Steps

1. Enter recipient address
2. Set value (Wei)
3. Call `sendTinyETH`

---

## 🌐 Frontend Integration (ethers.js)

### Install

```bash
npm install ethers
```

---

### Setup

```js
import { ethers } from "ethers";

const provider = new ethers.WebSocketProvider("YOUR_WSS_RPC");

const contractAddress = "0xa15618b00619a8b1291b40115c7dCf3Bd119FC86";

const abi = [
  "function sendTinyETH(address recipient) payable",
  "event TinySent(address indexed from, address indexed to, uint256 amount)"
];

const contract = new ethers.Contract(contractAddress, abi, provider);
```

---

### Send Transaction

```js
const signer = await provider.getSigner();
const contractWithSigner = contract.connect(signer);

await contractWithSigner.sendTinyETH("RECIPIENT_ADDRESS", {
  value: ethers.parseEther("0.0001")
});
```

---

### Listen to Events

```js
contract.on("TinySent", (from, to, amount) => {
  console.log(from, to, ethers.formatEther(amount));
});
```

---

## 🔐 Security (VERY IMPORTANT)

### ❌ NEVER DO THIS

Do NOT store your private key in `.env` like this:

```
PRIVATE_KEY=0xabc123...
```

---

## ✅ Secure Method (Encrypted Keystore)

### Step 1: Open WSL Terminal

### Step 2: Run

```bash
cast wallet import myWallet --interactive
```

---

### Step 3: Follow Prompts

* Enter your private key (hidden input)
* Create a strong password

---

### Step 4: Result

* Your key is encrypted and stored in:

```
~/.foundry/keystores/
```

---

### Step 5: Use It

```bash
cast send 0xa15618b00619a8b1291b40115c7dCf3Bd119FC86 \
"sendTinyETH(address)" <RECIPIENT> \
--value 100000000000000 \
--account myWallet
```

You’ll be prompted for your password — no private key exposure.

---

## 🏗️ Architecture

```
User A → Contract → User B
            ↓
        Event Emitted
            ↓
 ┌──────────────┬───────────────┐
 │ Frontend     │ Backend       │
 │ ethers.js    │ Indexer       │
 │ WebSockets   │ Database      │
 └──────────────┴───────────────┘
```

---

## ⚠️ Notes

* Contract does NOT hold funds
* ETH must be sent with each call
* Fixed transfer amount = `0.0001 ETH`
* Extra ETH is refunded automatically

---

## 🚀 Future Improvements

* Batch transfers
* Dashboard UI
* Gasless transactions
* Analytics

---

## 📄 License

MIT
