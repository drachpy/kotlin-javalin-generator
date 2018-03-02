#!/bin/bash

# Requirements:
# 1. IDEA + Kotlin
# 2. Maven project with archtype "org.jetbrains.kotlin:kotlin-archtype-jvm"
# 3. GroupID = "app"
# 4. With dependencies: Javalin + Jackson = to be added to pom.xml
# 5. And this script must be copied on the root directory of the project

ROOT=src/main/kotlin/app
APP_PORT=7000
VERB=$1
MODULE_NAME=$2
ROUTE_PATH=$ROOT/App.kt
MODULE_NAME_LOWER=${MODULE_NAME,,}
SPEC_PATH=$ROOT/specs
MODULE_PATH=$SPEC_PATH/${MODULE_NAME,,}
MODEL_PATH=$MODULE_PATH/Model.kt
LOGIC_PATH=$MODULE_PATH/Logic.kt

if [ "$VERB" = "INIT" ]; then

    if [ ! -f $ROUTE_PATH ]; then
        echo "package app" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "import io.javalin.Javalin" >> $ROUTE_PATH
        echo "import io.javalin.ApiBuilder.*" >> $ROUTE_PATH
        echo "import de.jupf.staticlog.Log" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "fun main(args: Array<String>) {" >> $ROUTE_PATH
        echo "    val app = Javalin.create().apply {" >> $ROUTE_PATH
        echo "        port($APP_PORT)" >> $ROUTE_PATH
        echo "        exception(Exception::class.java) { e, ctx -> e.printStackTrace() }" >> $ROUTE_PATH
        echo "        error(404) { ctx -> ctx.json(\"404. This is not the response that you are looking for.\") }" >> $ROUTE_PATH
        echo "    }.start()" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "    app.routes {" >> $ROUTE_PATH
        echo "        get(\"/ping\") { ctx -> ctx.json(\"Pong\") }" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "    }" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "    Log.info(\"API STARTED. Listening at $APP_PORT\")" >> $ROUTE_PATH
        echo "}" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
    fi

    exit 1
fi


if [ ! -d $SPEC_PATH ]; then
    mkdir $SPEC_PATH
fi

if [ ! -d $MODULE_PATH ]; then
    mkdir $MODULE_PATH
fi

if [ ! -f $MODEL_PATH ]; then
    echo -e "package app.${MODULE_NAME,,}\n" >> $MODEL_PATH
fi

if [ ! -f $LOGIC_PATH ]; then
    echo -e "package app.${MODULE_NAME,,}\n" >> $LOGIC_PATH
    echo -e "\nclass $MODULE_NAME {\n\n}\n" >> $LOGIC_PATH
fi

if [[ "$VERB" =~ ^("LIST"|"ALL")$ ]]; then
    VERB_FOR="List"
    ROUTE_FOR="get"

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [__id] Internal Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val __id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $LOGIC_PATH
    echo "fun ${VERB_FOR,,}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response()" >> $LOGIC_PATH

    # ROUTES
    echo "${ROUTE_FOR}(\"/${MODULE_NAME_LOWER}\") { ctx -> ctx.json(${MODULE_NAME}().${VERB_FOR,,}(${MODULE_NAME}${VERB_FOR}Request())) }" >> $ROUTE_PATH
fi

if [[ "$VERB" =~ ^("GET"|"ALL")$ ]]; then
    VERB_FOR="Get"

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val id: String = \"\", val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $LOGIC_PATH
    echo "fun ${VERB_FOR,,}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response(id=req.id)" >> $LOGIC_PATH

    # ROUTES
    echo "${VERB_FOR,,}(\"/${MODULE_NAME_LOWER}/:id\") { ctx -> ctx.json(${MODULE_NAME}().${VERB_FOR,,}(${MODULE_NAME}${VERB_FOR}Request(ctx.param(\"id\").toString()))) }" >> $ROUTE_PATH
fi

writer_upsert () {
    VERB_FOR=$1

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val id: String = \"\", val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $LOGIC_PATH
    echo "fun ${VERB_FOR,,}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response(id=req.id)" >> $LOGIC_PATH

    # ROUTES
    echo "${VERB_FOR,,}(\"/${MODULE_NAME_LOWER}\") { ctx -> ctx.json(${MODULE_NAME}().${VERB_FOR,,}(ctx.bodyAsClass(${MODULE_NAME}${VERB_FOR}Request::class.java))) }" >> $ROUTE_PATH

}

if [[ "$VERB" =~ ^("POST"|"ALL")$ ]]; then
    writer_upsert "Post"
fi

if [[ "$VERB" =~ ^("PUT"|"ALL")$ ]]; then
    writer_upsert "Put"
fi

if [[ "$VERB" =~ ^("PATCH"|"ALL")$ ]]; then
    writer_upsert "Patch"
fi


if [[ "$VERB" =~ ^("DELETE"|"ALL")$ ]]; then
    writer_upsert "Delete"
fi
