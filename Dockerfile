# ---- builder ----
FROM node:24-alpine AS builder
WORKDIR /app

# install deps (cache package.json)
COPY package*.json ./
RUN npm ci --silent

# copy and build
COPY . .
RUN npm run build

# ---- runtime ----
FROM node:24-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# copy only production deps
COPY package*.json ./
RUN npm ci --production --silent

# copy compiled files
COPY --from=builder /app/dist ./dist

# open port
EXPOSE 3000
# start the compiled app
CMD ["node", "dist/main"]
