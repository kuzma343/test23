FROM ubuntu:23.04
RUN apt-get update && \
    apt-get install -y dotnet-sdk-6.0 nodejs npm git

# Install yarn as an alternative package manager for react-scripts
RUN npm install -g yarn

# Clone the cloud repository
COPY cloud /app/cloud

# Change to the FrontEnd/my-app directory
WORKDIR /app/cloud/FrontEnd/my-app

# Install react-scripts as a development dependency
RUN yarn add --dev react-scripts

# Start the app using react-scripts
CMD ["yarn", "start"]
