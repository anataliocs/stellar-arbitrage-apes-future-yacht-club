import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  transpilePackages: [
    'passkey-kit', 
    'passkey-factory-sdk', 
    'passkey-kit-sdk',
    'sac-sdk',
    'chat-demo-sdk',
  ],
  output: "standalone"
};

export default nextConfig;
