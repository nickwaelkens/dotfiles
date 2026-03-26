function git-cleanup --description "Delete merged branches and stale stashes with dry-run confirmation"
    argparse h/help 'stash-age=!_validate_int --min 1' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: git-cleanup [--stash-age DAYS]"
        echo ""
        echo "Clean up local branches merged into main and stashes older than a threshold."
        echo ""
        echo "Options:"
        echo "  --stash-age DAYS  Stash age threshold in days (default: 14)"
        echo "  -h, --help        Show this help"
        return 0
    end

    if not git rev-parse --is-inside-work-tree &>/dev/null
        echo (set_color red)"Not inside a git repository."(set_color normal)
        return 1
    end

    set -l stash_age_days 14
    if set -q _flag_stash_age
        set stash_age_days $_flag_stash_age
    end

    set -l current_branch (git branch --show-current)

    # --- Phase 1: Dry Run ---

    echo (set_color --bold cyan)"=== Git Cleanup Dry Run ==="(set_color normal)
    echo ""

    # Merged branches
    set -l merged_branches
    for branch in (git branch --merged main --format '%(refname:short)')
        if test "$branch" != main -a "$branch" != "$current_branch"
            set -a merged_branches $branch
        end
    end

    set -l branch_count (count $merged_branches)
    if test $branch_count -gt 0
        echo (set_color yellow)"Branches merged into main ($branch_count):"(set_color normal)
        for branch in $merged_branches
            echo "  - $branch"
        end
    else
        echo (set_color green)"No merged branches to clean up."(set_color normal)
    end

    echo ""

    # Stale stashes
    set -l now (date +%s)
    set -l threshold (math "$stash_age_days * 86400")
    set -l stale_stash_indices
    set -l stale_stash_descriptions

    for i in (seq 0 (math (git stash list | count) - 1))
        set -l stash_ref "stash@{$i}"
        set -l stash_timestamp (git log -1 --format='%ct' $stash_ref 2>/dev/null)
        if test -z "$stash_timestamp"
            continue
        end

        set -l age_seconds (math "$now - $stash_timestamp")
        if test $age_seconds -ge $threshold
            set -l age_days (math "floor($age_seconds / 86400)")
            set -l stash_desc (git stash list | sed -n (math "$i + 1")p)
            set -a stale_stash_indices $i
            set -a stale_stash_descriptions "$stash_desc ($age_days days old)"
        end
    end

    set -l stash_count (count $stale_stash_indices)
    if test $stash_count -gt 0
        echo (set_color yellow)"Stashes older than $stash_age_days days ($stash_count):"(set_color normal)
        for desc in $stale_stash_descriptions
            echo "  - $desc"
        end
    else
        echo (set_color green)"No stale stashes to clean up."(set_color normal)
    end

    echo ""

    # Nothing to do?
    if test $branch_count -eq 0 -a $stash_count -eq 0
        echo (set_color green)"Nothing to clean up!"(set_color normal)
        return 0
    end

    # --- Summary + Confirmation ---

    echo (set_color --bold)"Will delete $branch_count branch(es) and $stash_count stash(es)."(set_color normal)
    read -P (set_color --bold red)"Proceed? [y/N] "(set_color normal) -l confirm

    if test "$confirm" != y -a "$confirm" != Y
        echo "Aborted."
        return 0
    end

    # --- Phase 2: Deletion ---

    echo ""

    # Delete merged branches
    for branch in $merged_branches
        echo (set_color cyan)"Deleting branch: $branch"(set_color normal)
        git branch -d $branch
    end

    # Drop stashes in reverse order so indices stay valid
    for i in (seq (math "$stash_count - 1") -1 0)
        set -l idx $stale_stash_indices[(math "$i + 1")]
        echo (set_color cyan)"Dropping stash@{$idx}"(set_color normal)
        git stash drop "stash@{$idx}"
    end

    echo ""
    echo (set_color --bold green)"Cleanup complete!"(set_color normal)
end
