const nextConfig: NextConfig = {
    experimental: {
        appDir: true,
    },
    webpack: (config) => {
        return config; // Use Webpack without additional configuration
    },
};

export default nextConfig;
