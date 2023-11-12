#!/usr/bin/env python

import os
import subprocess
import sys
import pexpect


def main():
    try:
        gpg_process = subprocess.run(
            (
                'gpg',
                '--decrypt',
                os.path.join(
                    os.environ['HOME'],
                    '.ssh',
                    'key_password_vault.asc',
                )
            ),
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as err:
        print(err)
        print(err.stderr.decode())
        sys.exit(1)

    entries = (
        line.split(' ', 1)
        for line in (
            line.strip()
            for line in gpg_process.stdout.decode().split('\n')
        )
        if line
    )

    for identity_file_path, password in entries:
        print(f'{identity_file_path}')
        child = pexpect.spawn(
            'ssh-add',
            [identity_file_path],
        )
        child.expect(f'Enter passphrase for {identity_file_path}:')
        child.sendline(password)
        child.expect(pexpect.EOF)


if __name__ == '__main__':
    main()
