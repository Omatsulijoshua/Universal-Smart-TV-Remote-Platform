# Dockerfile for NestJS API Backend
FROM node:20-alpine AS builder

WORKDIR /app

COPY shared/ts ./shared/ts
RUN cd shared/ts && npm install && npm run build

COPY backend/package*.json ./backend/
RUN cd backend && npm install

COPY backend ./backend
RUN cd backend && npm run build

FROM node:20-alpine AS runner
WORKDIR /app

COPY --from=builder /app/shared/ts /app/shared/ts
COPY --from=builder /app/backend/package*.json ./backend/
COPY --from=builder /app/backend/dist ./backend/dist
COPY --from=builder /app/backend/node_modules ./backend/node_modules

WORKDIR /app/backend
EXPOSE 3000
CMD ["npm", "run", "start"]
