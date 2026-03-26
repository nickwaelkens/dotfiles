function git-pull-stash
    # Store the current branch name
    set current_branch (git branch --show-current)

    # Check if there are any changes to stash
    if git diff-index --quiet HEAD --
        # No changes, just pull
        echo "No local changes, pulling from origin/main..."
        git pull origin main
    else
        # There are changes, stash them
        echo "Stashing local changes..."
        git stash push -m "Auto-stash before pulling origin/main"

        # Pull from origin/main
        echo "Pulling from origin/main..."
        git pull origin main

        # Pop the stash
        echo "Restoring stashed changes..."
        if git stash pop
            echo "✓ Successfully restored your changes"
        else
            echo "⚠ Merge conflicts detected. Your changes are still in the stash."
            echo "Run 'git stash list' to see stashes and 'git stash pop' to try again."
        end
    end
end