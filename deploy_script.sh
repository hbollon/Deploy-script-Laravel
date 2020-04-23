#!/bin/bash

# Maintenance mode
php artisan down

# Git pull
git reset --hard
git pull origin master 

# Update PHP dependencies
composer install --no-interaction --no-dev --prefer-dist

# Update database
php artisan migrate --force

# Clear caches
php artisan cache:clear
php artisan route:clear
php artisan route:cache
php artisan config:clear
php artisan view:clear

# Clear expired password reset tokens
php artisan auth:clear-resets

# Reset and link ressource folder
rm public/storage
php artisan storage:link

# Install node dependencies and build prod assets
npm install
npm run prod

# Set rights to app folders
chmod -R 775 storage/ bootstrap/cache/

# Change config for prod
mv .env.prod .env
mv public/.htaccess.prod public/.htaccess

# Stop maintenance mode
php artisan up


