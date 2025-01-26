# Use Node.js LTS
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# Install pnpm and dependencies
RUN npm install -g pnpm
RUN pnpm install

# Copy the rest of the backend code
COPY . .

# Build the TypeScript code
RUN pnpm build

# Expose the backend port
EXPOSE 8080

# Start the backend
CMD ["pnpm", "dev"]