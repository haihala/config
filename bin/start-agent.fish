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
    if [ (cat /proc/$SSH_AGENT_PID/cmdline 2>/dev/null | sed 's:\x00::g') != ssh-agent-c ]
        startSshAgent
    end
else
    startSshAgent
end
