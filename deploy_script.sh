#!/bin/bash

# Maintenance mode
php7.3 artisan down

# Git pull
git reset --hard
git pull origin master 

# Update PHP dependencies
/usr/bin/php7.3-cli composer.phar install --no-interaction --no-dev --prefer-dist

# Update database
php7.3 artisan migrate --force

# Clear caches
php7.3 artisan cache:clear
php7.3 artisan route:clear
php7.3 artisan route:cache
php7.3 artisan config:clear
php7.3 artisan view:clear

# Clear expired password reset tokens
php7.3 artisan auth:clear-resets

# Reset and link ressource folder
rm public/storage
php7.3 artisan storage:link

# Install node dependencies and build prod assets
npm install
npm run prod

# Set rights to app folders
chmod -R 775 storage/ bootstrap/cache/

# Change config for prod
rm .env
mv .env.prod .env
rm public/.htaccess
mv public/.htaccess.prod public/.htaccess

# Stop maintenance mode
php7.3 artisan up


