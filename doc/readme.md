# JanTechTestApp embryo to be completely changed

[![Release]][release]

[release]:https://github.com/jnorback/JanTechTestApp/releases/latest

## Documentation structure

[readme.md](readme.md) - this file
[config.md](config.md) - how to configure the application

## JN Tech Test Application

An application designed to be ran on a Linux system to download the latest release of Vibrato's Tech Test Application, create the environment to run it in an AWS ECS container

It is completely self contained, and should not require any additional dependencies to run.

## Install

1. Download latest binary from release
2. unzip into desired location
3. Configure the JanTechTestApp application
3. and you should be good to go

## Start server

update `conf.toml` with database settings (details on how to configure the application can be found in [config.md](config.md))

`./TechTestApp updatedb` to create a database, tables, and seed it with test data. Use `-s` to skip creating the database.

`./TechTestApp serve` will start serving requests

## Interesting endpoints

`/` - root endpoint that will load the SPA

`/api/tasks/` - api endpoint to create, read, update, and delete tasks

`/healthcheck/` - Used to validate the health of the application

## Repository structure

``` sh
.
├── assets      # Asset directory for the application
│   ├── css     # Contains all the css files for the web site
│   ├── images  # Contains all the images for teh web site
│   └── js      # Contains all the react javascript files
├── cmd         # Command line UI logic is managed in this location
├── config      # Contains the configuration logic for he application
├── daemon      # Contains the logic of the daemon that runs and controll the app
├── db          # Contains the data layet and db connectivity logic
├── doc         # Documentation folder
├── model       # Data model for the application
└── ui          # Web UI, routing, connectivity
```

## Application Architecture

![architecture](images/architecture.png)

The application itself is a React based single page application (SPA) with an API backend and a postgres database used for data persistence. It's been designed to be completely stateless and will deploy into most types of environments, be it container based or VM based.

## Build from source

### Reqirements

#### Golang

Application is build using golang, this can be installed in many ways, go to [golang](https://golang.org/) to download the version that suits you.

#### dep

dep is used for dependency management in golang, please download and install dep from the [official source](https://github.com/golang/dep).

Linux / MacOS: `curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh`

#### Docker

If building using docker you need to have docker installed on your local machine. Download from the [docker website](https://www.docker.com/get-started)

### Compiling the application locally

Download the application using go get:

`go get -d github.com/vibrato/VibratoTechTest`

run `build.sh` to download all the dependencies and compile the application

the `dist` folder contains the compiled web package

### Docker build using docker

To build a docker image with the application installed on it

`docker build . -t techtestapp:latest`

