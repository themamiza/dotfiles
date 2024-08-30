#!/bin/python3

### IMPORTS
import sys
import os
import getpass
import argparse
import re
from subprocess import run
from pathlib import Path

# Need to define this here as it is used in FUNCTIONS:
verbose = not False

### OBJECTS
class bcolors:
    HEADER = "\033[95m"     #]
    OKBLUE = "\033[94m"     #]
    OKCYAN = "\033[96m"     #]
    OKGREEN = "\033[92m"    #]
    WARNING = "\033[93m"    #]
    FAIL = "\033[91m"       #]
    ENDC = "\033[0m"        #]
    BOLD = "\033[1m"        #]
    UNDERLINE = "\033[4m"   #]

### FUNCTIONS
def error(error_message: str) -> None:
    print(f"{bcolors.FAIL}{bcolors.BOLD}ERROR ::{bcolors.ENDC} {bcolors.BOLD}{error_message}{bcolors.ENDC}", file=sys.stderr)
    exit(1)

def warning(warning_message: str) -> None:
    print(f"{bcolors.WARNING}{bcolors.BOLD}WARNING ::{bcolors.ENDC} {bcolors.BOLD}{warning_message}{bcolors.ENDC}")

def message(message: str) -> None:
    print(f"{bcolors.OKBLUE}{bcolors.BOLD}::{bcolors.ENDC} {bcolors.BOLD}{message}{bcolors.ENDC}")

def prompt(prompt: str) -> str:
    print(f"{bcolors.OKGREEN}{bcolors.BOLD}::{bcolors.ENDC} {bcolors.BOLD}{prompt}{bcolors.ENDC}", end="")
    return input()

def areYouSure() -> None:
    ans = prompt("Are you sure you want to continue? [Y/N] ")
    if not ans.lower() in ["y", "yes"]:
        exit(0)
    else:
        pass

def isRoot() -> bool:
    if os.getuid():
        return False
    else:
        return True

def username_isvalid(username: str) -> bool:
    if re.match("^[a-z_][a-z0-9_-]*$", username):
        return True
    else:
        return False

def passwd(username: str, password: str) -> None:
    run(["echo", f"{username}:{password}", "|", "chpasswd"], capture_output=verbose)

def chown(username: str, path: str) -> None:
    run(["chown", "-R", f"{username}:{username}", path], capture_output=verbose)

def getpasswd(username: str) -> str:
    while True:
        message(f"Setting password for user {username}")
        password1 = getpass.getpass()
        password2 = getpass.getpass("Retype Password: ")
        if password1 == password2:
            del password2
            return password1
        else:
            message("Passwords do not match. Please try again.")
            continue

def userExists(username: str) -> bool:
    if not run(["id", "-u", username], capture_output=verbose).returncode:
        return True
    else:
        return False

def refreshkeys() -> None:
    message("Refreshing Arch Keyring...")
    run(["pacman", "--noconfirm", "-S", "archlinux-keyring"], capture_output=verbose)

def installpkg(pkg: str) -> None:
    run(["pacman", "--noconfirm", "--needed", "-S", pkg], capture_output=verbose)

def isInstalled(pkg: str) -> bool:
    try:
        if run(["pacman", "-Qq", pkg], capture_output=verbose).returncode:
            return False
    except FileNotFoundError:
        return False
    return True
    run

def synchronize_time() -> None:
    message("Synchronizing system time to ensure successful and secure installation of software...")
    run(["timedatectl", "set-ntp", "true"], capture_output=verbose)

def addUserAndPass(username: str, password: str, login_shell: str) -> None:
    message(f"Creating user -> {username}")
    if userExists(username):
        run(["usermod", "-a", "-G", "wheel", "-s", login_shell, username], capture_output=verbose)
        os.makedirs(f"/home/{username}", exist_ok=True)
        chown(username, f"/home/{username}")
    else:
        run(["useradd", "-m", "-G", "wheel", "-s", login_shell, username], capture_output=verbose)

'''
def gitClone(url: str, path="") -> None:
    if path == "":
        run(["git", "clone", "--depth", "1", url], user=None, capture_output=verbose)
    else:
        run(["git", "clone", "--depth", "1", url, path], user=None, capture_output=verbose)
'''

### MAIN
if __name__ == "__main__":
    marbs_arg_parser = argparse.ArgumentParser(prog="marbs",
                                               description="Mamiza's Auto-Rice Bootstraping Script")
    marbs_arg_parser.add_argument('-u', '--username',
                                  default="mamiza",
                                  help="Sets username which marbs will be installed for.")
    marbs_arg_parser.add_argument('-s', '--shell',
                                  choices=["/bin/bash", "/bin/zsh"],
                                  default="/bin/zsh",
                                  help="Choose login shell for user.")
    marbs_arg_parser.add_argument('-v', '--verbose',
                                  action="store_false",
                                  help="Determines if output is captured.")
    args = marbs_arg_parser.parse_args()

    username = args.username
    verbose = args.verbose
    shell = args.shell

    repodir = Path(f"/home/{username}/.local/src")
    os.makedirs(repodir, exist_ok=True)
    chown(mamiza, repodir)

    if isRoot():
        error("Not running as root!")

    if not isInstalled("pacman"):
        error("Could not find `pacman`!")

    message("Refreshing pacman sync databases...")
    if run(["pacman", "-Sy"], capture_output=verbose).returncode:
        error("Could not refresh pacman sync database!")

    if not username_isvalid(username):
        error("Username is not valid")

    if userExists(username):
        warning(f"User `{username}` already exists!")
        message(f"{username}'s home directory will be overwritten!")
        areYouSure()

    password = getpasswd(username)

    message("The rest of the installation is automated. You can sit back and relax now.")
    areYouSure()

    refreshkeys()

    essentials = ["curl", "ca-certificates", "base-devel", "git", "zsh"]
    for p in essentials:
        message(f"Installing `{p}` which is required to configure other programs.")
        installpkg(p)
    del essentials

    synchronize_time()

    addUserAndPass(username, password, shell)
    del password

    sudoers_pacnew = Path("/etc/sudoers.pacnew")
    sudoers = Path("/etc/sudoers")
    if sudoers_pacnew.is_file():
        run(["cp", "-v", "-f", sudoers_pacnew, sudoers], capture_output=verbose)

    marbs_temp = Path("/etc/sudoers.d/marbs-temp")
    try:
        os.remove(marbs_temp)
    except FileNotFoundError:
        pass
    with open(marbs_temp, "w") as file:
        file.write("%wheel ALL=(ALL) NOPASSWD: ALL")

