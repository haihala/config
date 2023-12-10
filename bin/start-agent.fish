#!/usr/bin/env fish

set SshAgentEnvVarsFile ~/.sshagentenv

function startSshAgent
    set -l orig_umask (umask)
    umask 0077
    ssh-agent -c | sed /echo/d >$SshAgentEnvVarsFile
    . $SshAgentEnvVarsFile
    umask $orig_umask
    add-ssh-keys.py
end

if [ -e $SshAgentEnvVarsFile ]
    . $SshAgentEnvVarsFile

    if not pgrep -f ssh-agent >/dev/null
        startSshAgent
    end
else
    startSshAgent
end
