#!/usr/bin/env bash

# Requirements:
# 1. IDEA + Kotlin
# 2. Maven project with archtype "org.jetbrains.kotlin:kotlin-archtype-jvm"
# 3. GroupID = "app"
# 4. With dependencies: Javalin + Jackson = to be added to pom.xml
# 5. And this script must be copied on the root directory of the project

ROOT=src/main/kotlin/app
VERB=$1
ROUTE_PATH=$ROOT/App.kt

if [ "$VERB" = "INIT" ]; then
    echo "Initialising..."
    if [ ! -d $ROOT/models/ ]; then
        mkdir -p $ROOT/models/
    fi

    if [ ! -d $ROOT/modules/ ]; then
        mkdir -p $ROOT/modules/
    fi

    if [ ! -f $ROUTE_PATH ]; then
        echo "package app" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "import io.javalin.Javalin" >> $ROUTE_PATH
        echo "import io.javalin.ApiBuilder.*" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "import app.models.*" >> $ROUTE_PATH
        echo "import app.modules.*" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "fun main(args: Array<String>) {" >> $ROUTE_PATH
        echo "    val app = Javalin.create().apply {" >> $ROUTE_PATH
        echo "        port(7000)" >> $ROUTE_PATH
        echo "        exception(Exception::class.java) { e, ctx -> e.printStackTrace() }" >> $ROUTE_PATH
        echo "        error(404) { ctx -> ctx.json(\"404. This is not the response that you are looking for.\") }" >> $ROUTE_PATH
        echo "    }.start()" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "    app.routes {" >> $ROUTE_PATH
        echo "        get(\"/ping\") { it.json(\"Pong\") }" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
        echo "    }" >> $ROUTE_PATH
        echo "}" >> $ROUTE_PATH
        echo "" >> $ROUTE_PATH
    fi

    echo "FIN."
    exit 1
fi

MODULE_NAME=$2
MODULE_NAME_LOWER=${MODULE_NAME,,}
MODEL_PATH=$ROOT/models/$MODULE_NAME.kt
MODULE_PATH=$ROOT/modules/$MODULE_NAME.kt

if [ ! -f $MODEL_PATH ]; then
    echo -e "package app.models\n" >> $MODEL_PATH
fi

if [ ! -f $MODULE_PATH ]; then
    echo -e "package app.modules\n\nimport app.models.*\n" >> $MODULE_PATH
#    echo -e "/**\n * $MODULE_NAME module\n */" >> $MODULE_PATH
    echo -e "class $MODULE_NAME {\n\n}\n" >> $MODULE_PATH
fi

if [[ "$VERB" =~ ^("LIST"|"ALL")$ ]]; then
    VERB_FOR="List"
    VERB_FOR_LOWER="list"
    ROUTE_FOR="get"

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [__id] Internal Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val __id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $MODULE_PATH
    echo "fun ${VERB_FOR_LOWER}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response()" >> $MODULE_PATH

    # ROUTES
    echo "${ROUTE_FOR}(\"/${MODULE_NAME_LOWER}\") { it.json(${MODULE_NAME}().${VERB_FOR_LOWER}(${MODULE_NAME}${VERB_FOR}Request())) }" >> $ROUTE_PATH
fi

if [[ "$VERB" =~ ^("GET"|"ALL")$ ]]; then
    VERB_FOR="Get"
    VERB_FOR_LOWER="get"

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val id: String = \"\", val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $MODULE_PATH
    echo "fun ${VERB_FOR_LOWER}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response(id=req.id)" >> $MODULE_PATH

    # ROUTES
    echo "${VERB_FOR_LOWER}(\"/${MODULE_NAME_LOWER}/:id\") { it.json(${MODULE_NAME}().${VERB_FOR_LOWER}(${MODULE_NAME}${VERB_FOR}Request(ctx.param(\"id\").toString()))) }" >> $ROUTE_PATH
fi

writer_upsert () {
    VERB_FOR=$1
    VERB_FOR_LOWER=$1

    # MODELS
    echo "" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Request(val id: String = \"\")" >> $MODEL_PATH
#    echo -e "/**\n * @param [id] Id\n * @param [__comment] Internal Comment\n */" >> $MODEL_PATH
    echo "data class ${MODULE_NAME}${VERB_FOR}Response(val id: String = \"\", val __comment: String = \"${VERB_FOR}\")" >> $MODEL_PATH

    # MODULES
#    echo -e "\n/**\n * @param ${MODULE_NAME}${VERB_FOR}Request\n * @return ${MODULE_NAME}${VERB_FOR}Response\n\t */" >> $MODULE_PATH
    echo "fun ${VERB_FOR_LOWER}(req: ${MODULE_NAME}${VERB_FOR}Request) : ${MODULE_NAME}${VERB_FOR}Response = ${MODULE_NAME}${VERB_FOR}Response(id=req.id)" >> $MODULE_PATH

    # ROUTES
    echo "${VERB_FOR_LOWER}(\"/${MODULE_NAME_LOWER}\") { it.json(${MODULE_NAME}().${VERB_FOR_LOWER}(it.bodyAsClass(${MODULE_NAME}${VERB_FOR}Request::class.java))) }" >> $ROUTE_PATH

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
