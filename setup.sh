#!/bin/bash

set -euo pipefail

echo "---------------------------"
echo "AUTO PROJECT SETUP STARTING..."
echo "---------------------------"

read -p "Project name: " Field_of_Dreams_site

# Auto-configure Git identity
GIT_USER_NAME="Iain Sutherland"
GIT_USER_EMAIL="iain.sutherland849@googlemail.com"

current_git_user_name="$(git config --global user.name 2>/dev/null || true)"
if [ "$current_git_user_name" != "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
    echo "Set git user.name to $GIT_USER_NAME"
else
    echo "git user.name already set to $GIT_USER_NAME"
fi

current_git_user_email="$(git config --global user.email 2>/dev/null || true)"
if [ "$current_git_user_email" != "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
    echo "Set git user.email to $GIT_USER_EMAIL"
else
    echo "git user.email already set to $GIT_USER_EMAIL"
fi

mkdir "$Field_of_Dreams_site"
cd "$Field_of_Dreams_site"

echo "<h1>Hello World</h1>" > index.html

git init -b main
git add .

echo "Current Git status (pre-commit):"
git status -sb

git commit -m "Initial commit"

echo "Git status after commit (should be clean):"
git status -sb

# Ensure GitHub CLI is authenticated before creating the repo
if ! gh auth status &> /dev/null; then
    echo "GitHub CLI not authenticated. Launching login flow..."
    gh auth login
fi

# GitHub repo creation
gh repo create "$Field_of_Dreams_site" --public --source=. --remote=origin --push
git remote -v

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