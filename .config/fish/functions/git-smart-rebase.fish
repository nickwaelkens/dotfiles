function git-smart-rebase --description "Stash, pull main, and rebase current branch interactively"
    # Check if we're in a git repo
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not in a git repository"
        return 1
    end

    # Get current branch name
    set current_branch (git branch --show-current)

    # Don't run on main/master
    if test "$current_branch" = "main" -o "$current_branch" = "master"
        echo "❌ Already on $current_branch - no need to rebase"
        return 1
    end

    echo "🚀 Smart rebase starting on branch: $current_branch"

    # Check if there are any changes to stash
    if not git diff-index --quiet HEAD --
        set timestamp (date +"%Y%m%d_%H%M%S")
        set stash_message "smart_rebase_$current_branch"_"$timestamp"

        echo "📦 Stashing changes as: $stash_message"
        git stash push -m "$stash_message"

        if test $status -ne 0
            echo "❌ Failed to stash changes"
            return 1
        end

        set stashed true
    else
        echo "✅ No changes to stash"
        set stashed false
    end

    # Switch to main and pull
    echo "🔄 Switching to main and pulling latest..."
    git checkout main
    if test $status -ne 0
        echo "❌ Failed to switch to main"
        return 1
    end

    git pull origin main
    if test $status -ne 0
        echo "❌ Failed to pull from origin/main"
        git checkout "$current_branch"
        return 1
    end

    # Switch back to feature branch
    echo "🔀 Switching back to $current_branch"
    git checkout "$current_branch"

    if test $status -ne 0
        echo "❌ Failed to switch back to $current_branch"
        return 1
    end

    # Start the rebase
    echo "🔧 Starting rebase onto main..."
    git rebase main

    set rebase_status $status

    if test $rebase_status -eq 0
        echo "✅ Rebase completed successfully!"

        # Pop the stash if we stashed something
        if test "$stashed" = "true"
            echo "📂 Restoring your stashed changes..."
            git stash pop
            if test $status -eq 0
                echo "✅ Changes restored successfully!"
            else
                echo "⚠️  Warning: Could not restore stashed changes automatically"
                echo "💡 Your stash is still available - check with: git stash list"
            end
        end

        echo "🎉 All done! You're back on $current_branch with latest main changes"

    else
        echo ""
        echo "⚠️  REBASE CONFLICTS DETECTED"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🔧 Resolve conflicts in your editor, then choose:"
        echo ""
        echo "  git add <files>           # Stage resolved files"
        echo "  git rebase --continue     # Continue the rebase"
        echo ""
        echo "  OR"
        echo ""
        echo "  git rebase --abort        # Cancel and go back"
        echo ""
        echo "💡 After resolving conflicts, your stash will still be available"
        echo "   Run 'git stash pop' when you're ready to restore your changes"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    end
end