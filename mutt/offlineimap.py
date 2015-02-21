#!/usr/bin/env python

import getpass
import re, subprocess

from sys import platform

def get_keychain_pass(account=None, server=None):
    if platform == "darwin":
        params = {
            'security': '/usr/bin/security',
	    'user' : getpass.getuser(),
            'command': 'find-internet-password',
            'account': account,
            'server': server,
            'keychain': '/Users/' + getpass.getuser() + '/Library/Keychains/login.keychain',
        }
        command = "sudo -u %(user)s %(security)s -v %(command)s -g -a %(account)s -s %(server)s %(keychain)s" % params
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        outtext = [l for l in output.splitlines()
                   if l.startswith('password: ')][0]

        return re.match(r'password: "(.*)"', outtext).group(1)

    elif platform == "linux":
        account = os.path.basename(account)
        path = "/home/michael/.passwd/%s.gpg" % account
        args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
        try:
            return subprocess.check_output(args).strip()
        except subprocess.CalledProcessError:
            return ""
    else:
        print("unsupported plaform " + platform)

    return ""

def prime_gpg_agent():
    ret = False
    i = 1
    while not ret:
        ret = (_get_mail_password("prime") == "prime")
        if i > 2:
            from offlineimap.ui import getglobalui
            sys.stderr.write("Error reading in passwords. Terminating.\n")
            getglobalui().terminate()
        i += 1
    return ret

if platform == "linux":
    prime_gpg_agent()
