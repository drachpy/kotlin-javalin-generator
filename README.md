# Technologies used in this project
- Kotlin - https://kotlinlang.org/
- Javalin - https://github.com/tipsy/javalin
- IDEA - https://www.jetbrains.com/idea/
- Maven
- Dokka - https://github.com/Kotlin/dokka
- StaticLog - https://github.com/jupf/staticlog


# Usage:
1. To initialise new project

    `$ ./generator.sh INIT`

2. To create  module 'User' with all REST verbs

    `$ ./generator.sh ALL User`

3. Supported Verbs: ALL, LIST, GET, POST, PUT, PATCH, DELETE
    * ALL - this will generate all supported verbs
    * LIST - for returning a list of models. Useful for search feature.
    * GET - uses query string "id" and return single model
    * POST, PUT, PATCH, DELETE - uses data request
    
    `$ ./generator.sh GET AccessList`
4. Sample routes that will be created when using `ALL`
    * GET - http://localhost:7000/user/1
    * LIST - http://localhost:7000/user
    * POST - http://localhost:7000/user
    * PUT - http://localhost:7000/user
    * PATCH - http://localhost:7000/user
    * DELETE - http://localhost:7000/user


# Notes

- models - this will containg data classes (ie Request/Response objects)
- modules - the business logic / data access


# To do:
1. Add GraphQL to SQL support - Postgres
2. ~~Logging~~ (now using StaticLog)
3. Authentication via JWT
4. ~~Minimal documentation~~ (now using Dokka)


# Any question?

You may contact me via drachpy@gmail.com or github.com/drachpy

