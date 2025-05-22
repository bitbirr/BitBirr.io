import { useEffect, useState } from 'react';

export default function Home() {
  const [tokenData, setTokenData] = useState({});
  const [holderStats, setHolderStats] = useState({});
  const tokenAddress = "EwBUeMFm8Zcn79iJkDns3NdcL8t8B6Xikh9dKgZtpump";

  useEffect(() => {
    fetch(`https://public-api.birdeye.so/public/token/${tokenAddress}?chain=solana`)
      .then(res => res.json())
      .then(data => setTokenData(data.data || {}));

    fetch(`https://public-api.solscan.io/token/holders?tokenAddress=${tokenAddress}&limit=10`)
      .then(res => res.json())
      .then(data => {
        const top10Share = (data.data || []).reduce((sum, h) => sum + h.share, 0).toFixed(2);
        const devShare = data.data[0]?.share.toFixed(2) || "0";
        setHolderStats({
          holders: data.data.length,
          top10: top10Share,
          devSupply: devShare
        });
      });
  }, []);

  return (
    <div className="min-h-screen bg-[#0e1014] text-white font-sans">
      <header className="bg-[#1a1d23] p-5 flex justify-between items-center shadow-md">
        <div className="text-2xl font-bold text-green-400">BitBirr</div>
        <nav className="space-x-6 text-sm text-gray-300">
          <a href="#hero" className="hover:text-white">Home</a>
          <a href="#tracker" className="hover:text-white">Live Tracker</a>
          <a href="#contact" className="hover:text-white">Contact</a>
        </nav>
      </header>

      <section id="hero" className="flex flex-col md:flex-row items-center justify-between px-8 py-20 bg-gradient-to-br from-[#14161a] to-[#1d2129]">
        <div className="md:w-1/2 mb-8 md:mb-0">
          <h1 className="text-4xl md:text-5xl font-bold leading-tight text-green-400 mb-4">Exchange Crypto & Birr Instantly</h1>
          <p className="text-gray-300 mb-6 text-lg">BitBirr empowers Ethiopian crypto traders to convert USDT to Birr and vice versa—fast, secure, and reliable.</p>
          <a href="#tracker" className="inline-block bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-lg font-semibold transition">Start Trading</a>
        </div>
        <div className="md:w-1/2">
          <img src="/assets/exchange-demo.png" alt="BitBirr Exchange" className="rounded-lg shadow-lg" />
        </div>
      </section>

      <section id="tracker" className="px-6 py-16 bg-[#121417]">
        <h2 className="text-3xl font-bold text-green-400 mb-6 text-center">🎉 TOKEN GRADUATED 🎉</h2>
        <div className="max-w-3xl mx-auto">
          <p className="mb-2"><strong>Ticker:</strong> {tokenData.symbol}</p>
          <p className="mb-4"><strong>Name:</strong> {tokenData.name}</p>

          <h3 className="text-xl text-green-300 mt-8 mb-2">💬 SOCIALS</h3>
          <p>X: <a href={`https://x.com/search?q=${tokenAddress}`} target="_blank" rel="noreferrer" className="text-blue-400 underline">Search</a></p>
          <p>Website: <a href={tokenData.website || "#"} className="text-blue-400 underline" target="_blank" rel="noreferrer">{tokenData.website || "Unknown"}</a></p>

          <h3 className="text-xl text-green-300 mt-8 mb-2">📊 MARKET DATA</h3>
          <ul className="list-disc ml-6 text-sm">
            <li>Market Cap: ${Math.round(tokenData.mc || 0).toLocaleString()}</li>
            <li>Liquidity: ${Math.round(tokenData.liquidity || 0).toLocaleString()}</li>
            <li>Volume 24h: ${Math.round(tokenData.volume24h || 0).toLocaleString()}</li>
            <li>LP Burned: Check Manually</li>
          </ul>

          <h3 className="text-xl text-green-300 mt-8 mb-2">🧑‍💻 HOLDER STATS</h3>
          <ul className="list-disc ml-6 text-sm">
            <li>Holders: ~{holderStats.holders}</li>
            <li>Top 10 Holders: {holderStats.top10}%</li>
            <li>Dev Supply: {holderStats.devSupply}%</li>
          </ul>
        </div>
      </section>

      <footer id="contact" className="bg-[#1a1d23] text-center py-6">
        <p className="text-gray-400">Contact: <a href="mailto:support@bitbirr.com" className="text-green-400 underline">support@bitbirr.com</a> | Telegram: <a href="https://t.me/BitBirrpay" className="text-green-400 underline">@BitBirrpay</a></p>
      </footer>
    </div>
  );
}