
const tokenAddress = "EwBUeMFm8Zcn79iJkDns3NdcL8t8B6Xikh9dKgZtpump";

async function loadTokenData() {
  try {
    const birdeyeRes = await fetch(`https://public-api.birdeye.so/public/token/${tokenAddress}?chain=solana`);
    const birdeye = await birdeyeRes.json();
    const data = birdeye.data;

    document.getElementById("name").textContent = data?.name || "Unknown";
    document.getElementById("marketCap").textContent = "$" + Math.round(data?.mc || 0).toLocaleString();
    document.getElementById("liquidity").textContent = "$" + Math.round(data?.liquidity || 0).toLocaleString();
    document.getElementById("volume").textContent = "$" + Math.round(data?.volume24h || 0).toLocaleString();
    document.getElementById("ticker").textContent = data?.symbol || tokenAddress.slice(0, 5);

    document.getElementById("xLink").href = "https://x.com/search?q=" + tokenAddress;
    document.getElementById("website").href = data?.website || "#";
    document.getElementById("website").textContent = data?.website || "Unknown";

    // Scam Checks: Market Cap, Liquidity, Website
    if ((data?.mc || 0) < 50000) {
      document.getElementById("marketCap").style.color = "red";
    }
    if ((data?.liquidity || 0) < 10000) {
      document.getElementById("liquidity").style.color = "red";
    }
    if (!data?.website || data.website.length < 10) {
      document.getElementById("website").style.color = "orange";
    }

  } catch (e) {
    console.error("Birdeye API Error:", e);
  }

  try {
    const solscanRes = await fetch(`https://public-api.solscan.io/token/holders?tokenAddress=${tokenAddress}&limit=10`);
    const solscan = await solscanRes.json();
    const holders = solscan?.data || [];
    const top10Share = holders.reduce((sum, h) => sum + h.share, 0).toFixed(2);
    const devShare = holders[0]?.share.toFixed(2) || "0";

    document.getElementById("holders").textContent = "~" + (holders[0]?.rank + holders.length);
    document.getElementById("top10").textContent = top10Share + "%";
    document.getElementById("devSupply").textContent = devShare + "%";

    // Scam Checks: High centralization
    if (top10Share > 70) {
      document.getElementById("top10").style.color = "red";
    }
    if (devShare > 20) {
      document.getElementById("devSupply").style.color = "red";
    }

  } catch (e) {
    console.error("SolScan API Error:", e);
  }

  // Honeypot/Trading check placeholder (mock style)
  const honeypotCheck = {
    canBuy: true,
    canSell: false,
    taxBuy: 0,
    taxSell: 80
  };

  if (!honeypotCheck.canSell || honeypotCheck.taxSell > 30) {
    const scamWarning = document.createElement("p");
    scamWarning.innerHTML = "<strong style='color:red'>WARNING:</strong> Token may be a honeypot or have high sell tax!";
    document.querySelector(".tracker").appendChild(scamWarning);
  }
}

document.addEventListener("DOMContentLoaded", loadTokenData);
