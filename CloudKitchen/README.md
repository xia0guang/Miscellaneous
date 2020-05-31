# Cloud Kitchen System Readme

## Run Instruction

### Option #1
If you have installed Xcode and updated to the newest version(11.5 or above),
You can `cd` to current folder `CloudKitchen` and type following command in your terminal:
```sh
swift CloudKitchen.swift
```
### Option #2
If you have installed Docker, type following commands:
```sh
docker-compose build
docker-compose up
```
### Option #3
There is some delay while printing logs by using #2 option, so if you are seeing the same issue,
please go to file: `DockerFile`, and comment line 11 and uncomment line 12. Type following commands:
```sh
docker-compose build
docker-compose up -d
docker exec -it cloudkitchen /bin/bash
```
and in the active remote bash session, type following command:
```sh
swift CloudKitchen.swift
```

## System Documentation
1. Defaule order rate is 2 and you can change it by change it in line 474
2. Orders are read from local JSON files instead download from web server
3. System architecture:
    a. language is swift

    b. Models: 

        * Shelf
        * Courier
        * Order

    c. Protocols:

        * Simulating: responsible for start and stop system, read order from json file
        * Ordering: responsible for handling receiving orders, discarding orders, and check orders status
        * Delivering: responsible for distributing couriers, and handling the logic of couriers arrives
        * Logging: responsible for general logging

4. Logging explains:
    1. It is supposed to log every single message of receiving orders, putting on shelf, discarding orders, delivering orders, along with current orders display on each shelf at the top
But there is some flickering while running the system in the docker and you might see otherwise.
[Here](https://www.youtube.com/watch?v=B356GU2ZMVc) is the example logs with order rate 5.
    2. Logs are also saved in the same directory within a file named with current timestamp after every run.

5. Implementation

    * When the system starts run, there is a timer scheduled every 1.0/orderRate to trigger the logic of receiving an order.
    * Along with the order received, a timer of random number (between 2,6) seconds will be set up, to trigger the logic of delivering orders
    * When receiving order, the system will also check if any order totally decayed by using provided formula. 
    * Regarding the calculating of order life, if the order is initially put on overflow shelf and moved to temp matched shelf, the decayed life on overflow shelf will be considered with `accumulatedDecayedLife` variable in order structure. 


