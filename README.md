# Intro to Databases 

Come one come all and listen to me sales pitch! In introducory database cources all across the land, teachers have their poor students install mountains of garbage to acomplish simple sql querys. To make matters worse, instead of using a sensable or light weight database backed like sqlite3, they forced these unsuspecting students into using mysql! The terror they felt having to carefully install the correct version, just to find that something went wrong. 

Fear no more oh lowly students, as I have containerized the garbage so you can use your precious drive storage for more usful programs like anything other than phpmyadmin. 


## Overview
The mysql container will create a folder in this directory called mysql_data. This directory holds all the files that mysql uses. Plz no touchie these files. 

### Prerequisites
Install `docker` and `docker-compose`. If you are going into CS, you should learn how to use both of these, as they are imensly powerful tools. In the event of an emergency plz remain calm and direct any and all questions to the nearest search engine.

### Running
Running is as easy as 

```sh
make up
```

### Stopping
To stop, or kill the containers

```sh
make down # gracefull 
make kill # forcefull
```

### housekeeping
To delete all the containers, and images (mysql:latest, and phpmyadmin/phpmyadmin:latest)

```sh
make clean
```

### phpmyadmin usage 
Once you launch the containers (`make up`), then you can proceed to http://localhost:5000 where you will be presented with a login page. The default creds are as follows (I'm aware that they are imaginative):

```
server: server
username: username
password: password
```

# Maintainer
- John Cunniff | big_J

