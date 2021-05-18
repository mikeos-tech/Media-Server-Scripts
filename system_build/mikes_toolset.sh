# mikes_toolset.sh 
# creator: Mike O'Shea 
# Updated: 13/05/2021 
# Carries out the command line install of the tools that I currently
# find useful when I am working from the command line.

# GNU General Public License, version 3

#!/bin/bash
sudo apt install -y rsync tmux tmuxinator build-essential git vim ssh fortune cowsay tig mc uncrustify

mkdir ~/.vim_spell

# Details of the tools this script installs
# rsync
# A tool that can synchronise files between two locations even across the network connections, that can utilise ssh.
# tmux
# A terminal multiplexer, which can create one or multiple terminals, that lets you manage them in Windows or Panes.
# You can also detach and reconnect to these terminals.
# tmuxinator
# A tool that lets you build and save templates for tmux sessions and automates the creation of them.
# build-essential
# A collection of Ubuntu software development tools including the C/C++ compiler and debugger
# git
# A distributed version control system used by programmers to manage source code during the development process
# vim
# Vi IMproved a text editor which is a clone of the vi text editor
# ssh
# Secure SHell a secure, encrypted means of connecting to a remote computer.
# fortune
# A Program that displays a fortune cookie, a randomly selected quote, when it is run.
# cowsay
# A command line tool that outputs piped text into an ASCII art picture of a cow, with a speech bubble.
# tig
# Text-mode Interface for Git
# mc
# Midnight commander, a text based file management tool
# uncrustify
# A very powerful source code beautifier for c, c++ and similar languages. The vim configuration I use makes 
# this work within vim.
