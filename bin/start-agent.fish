#!/usr/bin/env fish

set SshAgentEnvVarsFile ~/.sshagentenv

function startSshAgent
    set -l orig_umask (umask)
    umask 0077
    ssh-agent -c | sed /echo/d >$SshAgentEnvVarsFile
    source $SshAgentEnvVarsFile
    umask $orig_umask
end

if test -e $SshAgentEnvVarsFile
    source $SshAgentEnvVarsFile
end

# Ask the agent itself instead of trusting `pgrep ssh-agent`, which only proves
# that some agent exists somewhere. Exit codes: 0 reachable and holding keys,
# 1 reachable but empty, 2 unreachable.
ssh-add -l >/dev/null 2>&1

switch $status
    case 2
        startSshAgent
        add-ssh-keys.py
    case 1
        add-ssh-keys.py
end
