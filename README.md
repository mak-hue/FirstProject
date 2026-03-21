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

You can:

* View transactions
* Verify contract activity
* Track emitted events

---

## ⚙️ Features

* Send exactly **0.0001 ETH**
* Accepts extra ETH and refunds automatically
* Emits events for tracking (frontend + backend)
* Fully gas-optimized
* No fund storage (safer design)

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

If using **Remix**:

### Value (Wei)

```
100000000000000
```

### Steps

1. Enter recipient address
2. Set value (Wei)
3. Call `sendTinyETH`

---

## 🌐 Frontend Integration

Using **ethers.js**

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
  console.log("New transaction:");
  console.log(from, to, ethers.formatEther(amount));
});
```

---

## 🗄️ Backend Indexing

### Simple Listener

```js
contract.on("TinySent", async (from, to, amount, event) => {
  console.log({
    from,
    to,
    amount: amount.toString(),
    txHash: event.log.transactionHash
  });
});
```

---

## 🔐 Security (VERY IMPORTANT)

### ❌ NEVER DO THIS

Do NOT store your private key like this:

```
PRIVATE_KEY=0xabc123...
```

👉 This is dangerous and can expose your wallet.

---

## ✅ Use Encrypted Keystore Instead

Using Foundry (`cast`):

### Step 1: Open your WSL terminal

### Step 2: Run:

```bash
cast wallet import myWallet --interactive
```

---

### Step 3: What Happens Next

You will be prompted to:

1. **Enter your private key**

   * Paste it (it will be hidden)

2. **Create a password**

   * This encrypts your wallet

---

### Step 4: Result

* Your key is stored securely as an **encrypted keystore file**
* Located in:

```
~/.foundry/keystores/
```

---

### Step 5: Use It Safely

Instead of exposing your private key, you can now run:

```bash
cast send <CONTRACT_ADDRESS> "sendTinyETH(address)" <RECIPIENT> \
--value 100000000000000 \
--account myWallet
```

👉 It will prompt for your password when needed

---

## 🧠 Why This Matters

* Protects your funds
* Prevents accidental leaks (GitHub, .env, etc.)
* Industry best practice

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
* Transaction dashboard
* Gasless transactions
* Activity analytics

---

## 📄 License

MIT
