import { useState, useEffect } from "react";
import { ethers } from "ethers";
import Header from "./components/Header";
import PoolPanel from "./components/PoolPanel";

function App() {
  const [account, setAccount] = useState(null);

  const connectWallet = async () => {
    if (window.ethereum) {
      const [addr] = await window.ethereum.request({ method: "eth_requestAccounts" });
      setAccount(addr);
    }
  };

  return (
    <div className="min-h-screen bg-gray-900 text-white p-6">
      <Header account={account} connectWallet={connectWallet} />
      {account && <PoolPanel account={account} />}
    </div>
  );
}

export default App;
