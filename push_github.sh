#!/bin/bash
# Global Git configuration
git config --global credential.helper store
git config --global user.email "jeangabrielgoudiaby@gmail.com"
git config --global user.name "jgoudiab"
# Variables
REPO_NAME=$(basename "$PWD")  # Use the current directory name as the repository name
GITHUB_URL="https://api.github.com/user/repos"
# Commit message handling
commit="$1"
default_message="piscine-java"
if [ -z "$commit" ]; then
  commit="$default_message"
fi
# Function to check if GitHub repository exists
check_github_repo_exists() {
  curl -H "Authorization: token $GITHUB_TOKEN" \
       -s \
       -o /dev/null \
       -w "%{http_code}" \
       "https://api.github.com/repos/Jeanga7/$REPO_NAME"
}
# If GitHub repository doesn't exist, create it
if [ "$(check_github_repo_exists)" -eq 404 ]; then
  echo "Creating repository $REPO_NAME on GitHub..."
  curl -H "Authorization: token $GITHUB_TOKEN" \
       -d "{\"name\": \"$REPO_NAME\"}" \
       $GITHUB_URL
else
  echo "Repository $REPO_NAME already exists on GitHub."
fi
# Ensure the Gitea remote is set
if ! git remote get-url origin &>/dev/null; then
  git remote add origin "https://learn.zone01dakar.sn/git/jgoudiab/$REPO_NAME.git"
else
  echo "Remote 'origin' (Gitea) already exists."
fi
# Ensure the GitHub remote is set
if ! git remote get-url github &>/dev/null; then
  git remote add github "https://github.com/Jeanga7/$REPO_NAME.git"
else
  echo "Remote 'github' already exists."
fi
# Add, commit, and push changes
git add .
git commit -m "$commit"
# Push the changes to both remotes (Gitea and GitHub)
echo "Pushing changes to Gitea (origin) and GitHub (github)..."
git push origin
git push github
echo "Push completed successfully to both remotes!"
# utilisez cela pour sauvegarder votre token
# export GITHUB_TOKEN="votre_token_github"
# source ~/.bashrc   # ou source ~/.zshrc