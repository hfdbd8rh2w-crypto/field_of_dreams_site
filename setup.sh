#!/bin/bash

echo "---------------------------"
echo "AUTO PROJECT SETUP STARTING..."
echo "---------------------------"

read -p "Project name: " Field_of_Dreams_site
mkdir "$Field_of_Dreams_site"
cd "$Field_of_Dreams_site"

echo "<h1>Hello World</h1>" > index.html

git init
git add .
git commit -m "Initial commit"

# GitHub repo creation
gh repo create "$Field_of_Dreams_site" --public --source=. --remote=origin
git push -u origin main

# Vercel install
if ! command -v vercel &> /dev/null
then
    npm install -g vercel
fi

vercel login
vercel --prod

echo "---------------------------"
echo "FINISHED! 🚀"
echo "Your site is deployed and linked to GitHub."
echo "---------------------------"