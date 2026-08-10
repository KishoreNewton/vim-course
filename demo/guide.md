# The Terminal Command Handbook

A comprehensive reference for essential terminal commands.
Resources: [Linux Commands](https://linuxcommand.org/lc3_learning_the_shell.php)


## File System Navigation

- `pwd` — Print the current working directory
    - Shows the absolute path to where you are right now
    - Essential for knowing your location in the file system
- `cd` — Change directory to a new location
    - `cd ~` — Go to your home directory instantly
    - `cd ..` — Move up one directory level
    - `cd -` — Toggle between last two directories
    - `cd /var/log` — Jump to an absolute path directly
- `ls` — List all files and directories in the current location
    - `ls -la` — Show all files with detailed permissions and ownership
    - `ls -lh` — Display file sizes in human-readable format
    - `ls -lt` — Sort the listing by modification time
    - `ls -R` — Recursively list all subdirectories
- `tree` — Display directory structure as a visual tree
    - `tree -L 2` — Limit the display depth to two levels
    - `tree -I node_modules` — Ignore specific directories


## File Operations

Creating, moving, copying, and managing files are the most
common tasks you will perform on the command line every day.

### Creating Files and Directories

- `touch` — Create a new empty file or update its timestamp
    - `touch notes.txt` — Creates notes.txt if it does not exist
    - `touch file1.txt file2.txt` — Create multiple files at once
- `mkdir` — Make a new directory
    - `mkdir -p path/to/nested/dir` — Create parent directories too
    - `mkdir -m 755 secure_dir` — Set permissions during creation

### Copying and Moving

- `cp` — Copy files and directories to a new location
    - `cp file.txt backup/` — Copy a single file to backup folder
    - `cp -r project/ project_backup/` — Copy entire directory recursively
    - `cp -i file.txt dest/` — Interactive mode, asks before overwriting
- `mv` — Move or rename files and directories
    - `mv old_name.txt new_name.txt` — Rename a file
    - `mv file.txt ~/Documents/` — Move a file to another directory
    - `mv -n source dest` — No clobber, do not overwrite existing files

### Removing Files

- `rm` — Remove files permanently (be careful with this one!)
    - `rm file.txt` — Delete a single file
    - `rm -r directory/` — Remove a directory and all its contents
    - `rm -i *.log` — Interactive deletion, confirm each file


## Text Processing

The command line has incredibly powerful tools for searching,
filtering, and transforming text directly in your terminal.

### Searching and Filtering

- `grep` — Search file contents for matching patterns
    - `grep -r "pattern" .` — Recursive search through all files
    - `grep -i "pattern" file` — Case insensitive search
    - `grep -n "pattern" file` — Show matching line numbers
    - `grep -v "pattern" file` — Show lines that do NOT match
    - `grep -c "pattern" file` — Count the number of matches
- `find` — Search for files by name, type, or other attributes
    - `find . -name "*.txt"` — Find all text files recursively
    - `find . -type d -name "test"` — Find directories named test
    - `find . -mtime -7` — Files modified in the last seven days
    - `find . -size +100M` — Find files larger than 100 megabytes

### Text Manipulation

- `sed` — Stream editor for transforming text automatically
    - `sed 's/old/new/g' file` — Replace all occurrences in a file
    - `sed -n '10,20p' file` — Print only lines ten through twenty
    - `sed '/pattern/d' file` — Delete lines matching a pattern
- `awk` — Pattern scanning and text processing language
    - `awk '{print $1}' file` — Print the first column of each line
    - `awk -F: '{print $1}' /etc/passwd` — Use colon as delimiter
    - `awk 'NR>=10 && NR<=20' file` — Print lines ten to twenty
- `sort` — Sort lines of text files alphabetically or numerically
    - `sort -n file` — Numeric sort instead of alphabetical
    - `sort -r file` — Reverse the sorting order
    - `sort -u file` — Sort and remove duplicate lines
- `wc` — Count lines, words, and characters in files
    - `wc -l file` — Count only the number of lines
    - `wc -w file` — Count only the number of words


## System Information

Understanding your system resources and running processes
helps you diagnose issues and optimize performance.

### Process Management

- `ps` — Display information about running processes
    - `ps aux` — Show all running processes with details
    - `ps -ef` — Full format listing of every process
- `top` — Real-time display of system resource usage
    - Shows CPU usage, memory consumption, and process list
    - Press q to quit, k to kill a process by ID
- `htop` — An improved version of top with a better interface
    - Color-coded bars for CPU and memory usage
    - Mouse support for easier navigation and filtering
- `kill` — Send signals to processes to terminate them
    - `kill PID` — Send the default TERM signal gracefully
    - `kill -9 PID` — Force kill an unresponsive process
    - `killall name` — Kill all processes matching a name

### Disk and Memory

- `df` — Report file system disk space usage
    - `df -h` — Human-readable sizes (GB, MB instead of blocks)
    - `df -i` — Show inode usage instead of block usage
- `du` — Estimate file and directory space usage
    - `du -sh *` — Summary of each item in current directory
    - `du -sh . --max-depth=1` — One level deep summary
- `free` — Display memory usage statistics
    - `free -h` — Human-readable format for easy reading


## Networking

Essential commands for checking network connectivity,
downloading files, and troubleshooting connections.

### Connectivity

- `ping` — Test network connectivity to a remote host
    - `ping -c 5 example.com` — Send exactly five ping packets
    - `ping -i 0.5 host` — Set interval between pings to half second
- `curl` — Transfer data from or to a server using URLs
    - `curl https://api.example.com/data` — Fetch content from a URL
    - `curl -o file.zip https://example.com/download` — Save to file
    - `curl -X POST -d '{"key":"value"}' URL` — Send POST request
- `wget` — Download files from the web non-interactively
    - `wget https://example.com/file.tar.gz` — Download a single file
    - `wget -r -l 2 https://example.com` — Recursive download
- `ssh` — Secure shell connection to remote machines
    - `ssh user@hostname` — Connect to a remote server
    - `ssh -p 2222 user@host` — Connect on a non-standard port
    - `ssh -L 8080:localhost:80 user@host` — Local port forwarding


## Version Control with Git

Git is the most widely used version control system. These
commands cover the essential daily workflow operations.

### Basic Workflow

- `git init` — Initialize a new Git repository in current directory
- `git clone URL` — Clone an existing repository from a remote URL
- `git status` — Show the current state of your working directory
- `git add` — Stage files for the next commit
    - `git add file.txt` — Stage a specific file
    - `git add .` — Stage all changed files in current directory
    - `git add -p` — Interactively stage parts of files
- `git commit` — Record staged changes with a message
    - `git commit -m "Add feature"` — Commit with inline message
    - `git commit --amend` — Modify the most recent commit

### Branching and Merging

- `git branch` — List, create, or delete branches
    - `git branch feature` — Create a new branch called feature
    - `git branch -d feature` — Delete a branch after merging
- `git checkout` — Switch between branches or restore files
    - `git checkout main` — Switch to the main branch
    - `git checkout -b new-branch` — Create and switch in one step
- `git merge` — Combine changes from another branch
    - `git merge feature` — Merge the feature branch into current
- `git log` — Show the commit history for the repository
    - `git log --oneline` — Compact one-line commit summaries
    - `git log --graph` — Visual representation of branch history


## Tips and Tricks

Advanced techniques that will make your terminal workflow
significantly faster and more efficient every day.

### Keyboard Shortcuts

- `Ctrl+R` — Reverse search through command history
- `Ctrl+A` — Jump to the beginning of the current line
- `Ctrl+E` — Jump to the end of the current line
- `Ctrl+W` — Delete the word before the cursor
- `Ctrl+U` — Delete everything before the cursor
- `Ctrl+L` — Clear the terminal screen instantly
- `Tab` — Auto-complete file names and commands

### Useful Patterns

- `command > file.txt` — Redirect output to a file (overwrite)
- `command >> file.txt` — Append output to a file
- `command1 | command2` — Pipe output from one command to another
- `command 2>&1` — Redirect stderr to stdout for logging
- `!!` — Repeat the last command you ran
- `!$` — Use the last argument from the previous command
- `command &` — Run a command in the background

### Resources

For more information and deeper learning, check these links:

- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- [The Linux Command Line Book](https://linuxcommand.org/tlcl.php)
- [Explain Shell](https://explainshell.com/) — Break down any command
- [TLDR Pages](https://tldr.sh/) — Simplified command documentation
