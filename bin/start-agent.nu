#!/usr/bin/env nu

const SshAgentEnvVarsFile = "~/.sshagentenv"
# This is a bit wonky but I wanted to maintain the ability to source the file
def startSshAgent [] {
    ssh-agent |
        sed /echo/d |
        lines |
        parse "{varname}={value}; export {_};" |
        each {|r| load-env { ($r.varname): ($r.value) }; echo $"$env.($r.varname) = ($r.value)"} |
        str join (char nl) |
        save -f $SshAgentEnvVarsFile
    add-ssh-keys.py
}

if ($SshAgentEnvVarsFile | path expand | path exists) {
    open $SshAgentEnvVarsFile |
        lines |
        parse "$env.{key} = {value}" |
        reduce -f {} { |it, acc| $acc | upsert $it.key $it.value } |
        load-env

    let pth = $"/proc/($env.SSH_AGENT_PID)/cmdline"
    if (($pth | path exists) == false) or (((cat $pth) | sed 's:\x00::g') != "ssh-agent") {
        startSshAgent
    }
} else {
    startSshAgent
}
