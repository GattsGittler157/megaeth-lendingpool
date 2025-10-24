export default function Header({ account, connectWallet }) {
  return (
    <div className="flex justify-between items-center mb-8">
      <h1 className="text-2xl font-bold text-cyan-400">MegaETH DeFi Pool</h1>
      <button
        onClick={connectWallet}
        className="bg-cyan-600 px-4 py-2 rounded hover:bg-cyan-700"
      >
        {account ? account.slice(0, 6) + "..." + account.slice(-4) : "Подключить кошелёк"}
      </button>
    </div>
  );
}
