# BASH learning

In this repositorium, I'm trying to learn something about bash scripting.

## Script add-local-user.sh

- *Input:* You have no need to put any arguments, just call this script in your terminal
- *Functionality:* This script is based on entering different parameteres (like USERNAME, PASSWORD and REAL NAME) by user to the terminal, using **read -p** command. Also there is some checking conditions, for example for if the user has superuser previleges.
- *Output:* In the output, user get displaying username, password and host.

## Script add-new-local-user.sh

This script is developing of the previous, but the goal remains the same, which is creating an account on the local system.
- *Input:*  You have to put at least one argument, which is USER_NAME and optionally supply some comments, for example real name of the user.
- *Functionality:* Compared to the previous script, here user data is taken as an argument. The password is generating automatically, using the hashed current date in "seconds + nanoseconds" 
- *Output:* In the output, user get displaying username, password and host, like in the previous script one.

