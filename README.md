# BASH learning

In this repositorium, I'm trying to learn something about bash scripting.

## Script add-local-user.sh

- *Input:* You have no need to put any arguments, just call this script in your terminal.
- *Functionality:* This script is based on entering different parameteres (like USERNAME, PASSWORD and REAL NAME) by user to the terminal, using ``read -p`` command. Also there is some checking conditions, for example for if the user has superuser previleges.
- *Output:* In the output, user get displaying username, password and host.

## Script add-new-local-user.sh

This script is developing of the previous, but the goal remains the same, which is creating an account on the local system.
- *Input:*  You have to put at least one argument, which is USER_NAME and optionally supply some comments, for example real name of the user.
- *Functionality:* Compared to the previous script, here user data is taken as an argument. The password is generating automatically, using the hashed current date in "seconds + nanoseconds".
- *Output:* In the output, user get displaying username, password and host, like in the previous script one.

## Script add-newer-local-user.sh

This script is modification of the previous for creating a new account, but with some modifications, which is adding some STD IN/OUT/ERR commands
- *Input:*  As it was in previous script, you have to put at least one argument (USER_NAME and optionally comments)
- *Functionality:* A special features were added to this script, like redirecting some messages to the STDERR (Standard error) using command ``1>&2``.
- *Output:* In the output, user get only username, password and host. Everything else is hiden by sending to the /dev/null using ``&> /dev/null`` after ``echo`` or other commends, for example ``useradd``.

## Script disable-local-user.sh

In this script one new command was used, which is called ``getopts``. This command is useful, when user want to realize some scenarios with different flags. For example ``command -l -s`` ( in this case it's better to use ``getopts`` function neither writing a huge piece of code using case-statement).

- *Input:* User should choose any option from the list ( -d for deleting, -r for removing home directory, -a for archiving)
- *Functionality:* The script is based on two main commands, that is ``getopts`` and ``for loop``. The first one is used for option processing and the second one for arguments processing, namely usernames.
- *Output:* In the output user can get archives of the users' accounts or deleted/disabled account. Also every step of the perfoming is  displayed in the terminal.

## Script show-attackers.sh

In this script some string editing commands where introduced like ``awk``, ``sort`` and ``uniq``.

- *Input:* User should provide a file with some log information like failed attempts with IP addresses.
- *Functionality:* This script counts how many failed attempts occured for different IP addresses. If this number is greter then defined variable LIMIT, then in the output user get csv format information.
- *Output:* User can get csv type of displaying information about failed login attempts. The view of the display is like count,IP,Location.

## Script show-attackers.sh

This script can help user to run multiple commands on many servers automatically. Prerequistes: user should have a file (Or use a default ``/vagrant/servers``} for listing all servers' names

- *Input:* User should provide a file with the names of the servers, any command for executing and additionally choose some option lik ``-v`` (displaying the name of procesing server)
- *Functionality:* The script is based on for loop, run through all supplied server names and perform different scenario according to the user choice
- *Output:* User can get some information displayed and the results of executing commands on other servers
