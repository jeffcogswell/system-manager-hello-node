# Use a lightweight Node.js base image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install --production

# Bundle app source
COPY . .

# Expose the port your app listens on
EXPOSE 3000

# Run the app
CMD ["node", "main.js"]

