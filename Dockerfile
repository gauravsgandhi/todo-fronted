# -------- Build stage --------
FROM node:18 AS BUILD
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run dev build    # outputs: /app/dist

# -------- Nginx runtime --------
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# optional: start clean
RUN rm -rf ./*

# copy built site
COPY --from=BUILD /app/dist ./

# Simple server block is fine if you place it in the default
# Otherwise you can drop a custom config in /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]