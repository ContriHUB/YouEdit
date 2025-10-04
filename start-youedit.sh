#!/bin/bash

# YouEdit - Single Command Startup Script
# This script starts all the required services for YouEdit

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}=================================${NC}"
echo -e "${GREEN}       YouEdit Starter         ${NC}"
echo -e "${BLUE}=================================${NC}"
echo -e "${YELLOW}Starting all services...${NC}"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed. Please install Node.js to continue.${NC}"
    exit 1
fi

# Function to check if a port is in use
is_port_in_use() {
    lsof -i:"$1" &> /dev/null
    return $?
}

# Check if required ports are available
required_ports=(3000 3001 3002 3003 5173)
for port in "${required_ports[@]}"; do
    if is_port_in_use "$port"; then
        echo -e "${RED}Error: Port $port is already in use. Please free up this port and try again.${NC}"
        exit 1
    fi
done

# Create logs directory if it doesn't exist
mkdir -p logs

# Install dependencies if node_modules doesn't exist
if [ ! -d "backend/node_modules" ]; then
    echo -e "${YELLOW}Installing backend dependencies...${NC}"
    cd backend && npm install
    cd ..
fi

if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    cd frontend && npm install
    cd ..
fi

# Start backend services
echo -e "${GREEN}Starting backend services...${NC}"

# Start app.js (main backend)
echo -e "${BLUE}Starting main backend server (app.js)...${NC}"
cd backend && node app.js > ../logs/app.log 2>&1 &
APP_PID=$!
echo -e "${GREEN}Main backend server started with PID: $APP_PID${NC}"

# Wait for app.js to start
sleep 2

# Start serve.js (download stream server)
echo -e "${BLUE}Starting download stream server (serve.js)...${NC}"
cd backend && node serve.js > ../logs/serve.log 2>&1 &
SERVE_PID=$!
echo -e "${GREEN}Download stream server started with PID: $SERVE_PID${NC}"

# Start tus.js (file upload server)
echo -e "${BLUE}Starting TUS file upload server (tus.js)...${NC}"
cd backend && node tus.js > ../logs/tus.log 2>&1 &
TUS_PID=$!
echo -e "${GREEN}TUS file upload server started with PID: $TUS_PID${NC}"

# Start youtube.js (YouTube API server)
echo -e "${BLUE}Starting YouTube API server (youtube.js)...${NC}"
cd backend && node youtube.js > ../logs/youtube.log 2>&1 &
YOUTUBE_PID=$!
echo -e "${GREEN}YouTube API server started with PID: $YOUTUBE_PID${NC}"

# Start frontend
echo -e "${BLUE}Starting frontend development server...${NC}"
cd frontend && npm run dev > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo -e "${GREEN}Frontend server started with PID: $FRONTEND_PID${NC}"

# Save PIDs to file for later cleanup
echo "$APP_PID $SERVE_PID $TUS_PID $YOUTUBE_PID $FRONTEND_PID" > .youedit_pids

# Wait for frontend to start
sleep 5

# Print access information
echo ""
echo -e "${BLUE}=================================${NC}"
echo -e "${GREEN}       YouEdit is running!      ${NC}"
echo -e "${BLUE}=================================${NC}"
echo -e "Frontend: ${YELLOW}http://localhost:5173${NC}"
echo -e "Backend API: ${YELLOW}http://localhost:3000${NC}"
echo ""
echo -e "${BLUE}Log files are saved in the logs directory:${NC}"
echo -e "- Main backend: ${YELLOW}logs/app.log${NC}"
echo -e "- Download server: ${YELLOW}logs/serve.log${NC}"
echo -e "- TUS server: ${YELLOW}logs/tus.log${NC}"
echo -e "- YouTube API server: ${YELLOW}logs/youtube.log${NC}"
echo -e "- Frontend: ${YELLOW}logs/frontend.log${NC}"
echo ""
echo -e "${YELLOW}To stop all services, run: ./stop-youedit.sh${NC}"
echo -e "${BLUE}=================================${NC}"

# Create stop script
cat > stop-youedit.sh << 'EOF'
#!/bin/bash

# YouEdit - Stop Script
# This script stops all YouEdit services

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================${NC}"
echo -e "${YELLOW}     Stopping YouEdit...       ${NC}"
echo -e "${BLUE}=================================${NC}"

if [ -f .youedit_pids ]; then
    # Read PIDs from file
    read -r APP_PID SERVE_PID TUS_PID YOUTUBE_PID FRONTEND_PID < .youedit_pids
    
    # Kill processes
    echo -e "${YELLOW}Stopping frontend server...${NC}"
    kill -9 $FRONTEND_PID 2>/dev/null || echo -e "${RED}Frontend server was not running.${NC}"
    
    echo -e "${YELLOW}Stopping YouTube API server...${NC}"
    kill -9 $YOUTUBE_PID 2>/dev/null || echo -e "${RED}YouTube API server was not running.${NC}"
    
    echo -e "${YELLOW}Stopping TUS file upload server...${NC}"
    kill -9 $TUS_PID 2>/dev/null || echo -e "${RED}TUS file upload server was not running.${NC}"
    
    echo -e "${YELLOW}Stopping download stream server...${NC}"
    kill -9 $SERVE_PID 2>/dev/null || echo -e "${RED}Download stream server was not running.${NC}"
    
    echo -e "${YELLOW}Stopping main backend server...${NC}"
    kill -9 $APP_PID 2>/dev/null || echo -e "${RED}Main backend server was not running.${NC}"
    
    # Remove PID file
    rm .youedit_pids
    
    echo -e "${GREEN}All YouEdit services have been stopped.${NC}"
else
    echo -e "${RED}No running YouEdit services found.${NC}"
fi

echo -e "${BLUE}=================================${NC}"
EOF

# Make stop script executable
chmod +x stop-youedit.sh

# Keep script running
wait $FRONTEND_PID