# Never publish an old tmux environment as the newest forwarded agent.
if [[ -n $SSH_CONNECTION && -z $TMUX && -S $SSH_AUTH_SOCK &&
      $SSH_AUTH_SOCK != $HOME/.local/state/flint/ssh-agent ]]; then
    () {
        local agent_dir=$HOME/.local/state/flint
        local incoming=$SSH_AUTH_SOCK

        # Restrict the socket directory to this user. Rename the link atomically
        # so existing jobs never observe a gap between forwarded connections.
        (
            umask 077
            mkdir -p "$agent_dir" &&
                [[ -O $agent_dir && ! -L $agent_dir ]] &&
                chmod 700 "$agent_dir" &&
                ln -s "$incoming" "$agent_dir/ssh-agent.$$" &&
                mv -f "$agent_dir/ssh-agent.$$" "$agent_dir/ssh-agent"
        ) || return
        export SSH_AUTH_SOCK=$agent_dir/ssh-agent
    }
elif [[ -n $SSH_CONNECTION && -S $HOME/.local/state/flint/ssh-agent ]]; then
    export SSH_AUTH_SOCK=$HOME/.local/state/flint/ssh-agent
fi
