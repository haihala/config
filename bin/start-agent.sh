#!/usr/bin/env bash

SshAgentEnvVarsFile=~/.sshagentenv
function startSshAgent()
{
  local orig_umask=$(umask)
  umask 0077
  ssh-agent | sed /echo/d > ${SshAgentEnvVarsFile}
  . ${SshAgentEnvVarsFile}
  umask ${orig_umask}
  add-ssh-keys.py
}

if [ -e ${SshAgentEnvVarsFile} ]
then
  . ${SshAgentEnvVarsFile}
  if [ "$(cat /proc/${SSH_AGENT_PID}/cmdline 2>/dev/null | sed 's:\x00::g')" != "ssh-agent" ]
  then
    startSshAgent
  fi
else
  startSshAgent
fi
