// Manual backport of Node 20's `autoSelectFamily` (Happy Eyeballs, RFC 8305)
// for the Windows 7 deployment target, which is capped at Node 13 — a runtime
// that has neither `autoSelectFamily` (Node 18.18/20) nor
// `dns.setDefaultResultOrder` (Node 14.18/16.4). On Node >= 20 this whole file
// is redundant (pg inherits Happy Eyeballs for free): delete it and revert
// knexfile.js to `host: process.env.DB_HOST`.
const net = require('net');
const dns = require('dns').promises;

const PROBE_TIMEOUT_MS = 3000;

// Resolve to `address` if a TCP connect to address:port succeeds, else null.
function tcpProbe(address, port) {
  return new Promise((resolve) => {
    const socket = new net.Socket();
    const finish = (ok) => { socket.destroy(); resolve(ok ? address : null); };
    socket.setTimeout(PROBE_TIMEOUT_MS);
    socket.once('connect', () => finish(true));
    socket.once('timeout', () => finish(false));
    socket.once('error', () => finish(false));
    socket.connect(port, address);
  });
}

// First address to accept a connection wins; null if all fail.
// (Promise.any isn't available on the Node version that supports Windows 7.)
function firstReachable(addresses, port) {
  return new Promise((resolve) => {
    let remaining = addresses.length;
    for (const address of addresses) {
      tcpProbe(address, port).then((res) => {
        if (res) resolve(res);
        else if (--remaining === 0) resolve(null);
      });
    }
  });
}

// Pick whichever IPv4/IPv6 address for `host` answers on `port` first.
// Returns `host` unchanged if it's already an IP literal or nothing is reachable.
async function pickReachableAddress(host, port) {
  if (net.isIP(host)) return host;
  const [v4, v6] = await Promise.all([
    dns.resolve4(host).catch(() => []),
    dns.resolve6(host).catch(() => []),
  ]);
  const addresses = [...v4, ...v6];
  if (addresses.length === 0) return host; // let pg do its own lookup
  return (await firstReachable(addresses, port)) || host;
}

module.exports = { pickReachableAddress };
