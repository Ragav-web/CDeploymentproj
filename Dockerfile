# Use Node.js base image
FROM node:16-bullseye

# Set the working directory
WORKDIR /usr/src/app

# Copy the application code
COPY app/ .

# Install dependencies (if any)
RUN npm install

# Expose the application port
EXPOSE 3000

# Run the application
CMD ["node", "app.js"]

