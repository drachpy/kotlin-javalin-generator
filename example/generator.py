#!/usr/bin/env python


import io
import os
import sys
from functional import seq


PROG, VERB, MODULE_NAME = sys.argv

ROOT="src/main/kotlin/app"
MODELS_DIR="{0}/models".format(ROOT)
MODULES_DIR="{0}/modules".format(ROOT)
ROUTE_FILE="{0}/App.kt".format(ROOT)
MODEL_FILE="{0}/{1}.kt".format(MODELS_DIR, MODULE_NAME)
MODULE_FILE="{0}/{1}.kt".format(MODULES_DIR, MODULE_NAME)

MODEL_CONTENT = ""
MODULE_CONTENT = ""
ROUTE_CONTENT = ""

if not os.path.isfile(ROUTE_FILE):
    print "Initialising appliation..."
    if not os.path.isdir(MODELS_DIR):
        os.makedirs(MODELS_DIR)
    if not os.path.isdir(MODULES_DIR):
        os.makedirs(MODULES_DIR)

    ROUTE_CONTENT = """package app

import io.javalin.Javalin
import io.javalin.ApiBuilder.*

import app.models.*
import app.modules.*


fun main(args: Array<String>) {
    val app = Javalin.create().apply {
        port(7000)
        exception(Exception::class.java) { e, ctx -> e.printStackTrace() }
        error(404) { ctx -> ctx.json("404. This is not the response that you are looking for.") }
    }.start()

    app.routes {
        get("/ping") { it.json("Pong") }

    }
}
"""

if not os.path.isfile(MODEL_FILE):
    MODEL_CONTENT = """package app.models
    
"""

if not os.path.isfile(MODULE_FILE):
    MODULE_CONTENT = """package app.modules

import app.models.*
    
"""

### MODELS
if VERB.lower() in ("list", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}ListRequest(val __id: String = "")
data class {0}ListResponse(val __comment: String = "List")
""".format(MODULE_NAME)

if VERB.lower() in ("get", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}GetRequest(val id: String = "")
data class {0}GetResponse(val id: String = "", val __comment: String = "Get")
""".format(MODULE_NAME)

if VERB.lower() in ("post", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}PostRequest(val id: String = "")
data class {0}PostResponse(val id: String = "", val __comment: String = "Post")
""".format(MODULE_NAME)

if VERB.lower() in ("put", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}PutRequest(val id: String = "")
data class {0}PutResponse(val id: String = "", val __comment: String = "Put")
""".format(MODULE_NAME)

if VERB.lower() in ("patch", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}PatchRequest(val id: String = "")
data class {0}PatchResponse(val id: String = "", val __comment: String = "Patch")
""".format(MODULE_NAME)

if VERB.lower() in ("delete", "all"):
    MODEL_CONTENT = MODEL_CONTENT + """
data class {0}DeleteRequest(val id: String = "")
data class {0}DeleteResponse(val id: String = "", val __comment: String = "Delete")
""".format(MODULE_NAME)


### MODULES
if VERB.lower() in ("list", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun list{0}(req: {0}ListRequest) : {0}ListResponse = {0}ListResponse()""".format(MODULE_NAME)

if VERB.lower() in ("get", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun get{0}(req: {0}GetRequest) : {0}GetResponse = {0}GetResponse(id=req.id)""".format(MODULE_NAME)

if VERB.lower() in ("post", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun post{0}(req: {0}PostRequest) : {0}PostResponse = {0}PostResponse(id=req.id)""".format(MODULE_NAME)

if VERB.lower() in ("put", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun put{0}(req: {0}PutRequest) : {0}PutResponse = {0}PutResponse(id=req.id)""".format(MODULE_NAME)

if VERB.lower() in ("patch", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun patch{0}(req: {0}PatchRequest) : {0}PatchResponse = {0}PatchResponse(id=req.id)""".format(MODULE_NAME)

if VERB.lower() in ("delete", "all"):
    MODULE_CONTENT = MODULE_CONTENT + """
fun delete{0}(req: {0}DeleteRequest) : {0}DeleteResponse = {0}DeleteResponse(id=req.id)""".format(MODULE_NAME)


### ROUTES

if VERB.lower() in ("list", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
get("/{0}") {{ it.json({1}().list({1}ListRequest())) }}""".format(MODULE_NAME.lower(), MODULE_NAME)

if VERB.lower() in ("get", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
get("/{0}/:id") {{ it.json({1}().get({1}GetRequest(ctx.param("id").toString()))) }}""".format(MODULE_NAME.lower(), MODULE_NAME)

if VERB.lower() in ("post", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
Post("/{0}") {{ it.json({1}().Post(it.bodyAsClass({1}PostRequest::class.java))) }}""".format(MODULE_NAME.lower(), MODULE_NAME)

if VERB.lower() in ("put", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
Put("/{0}") {{ it.json({1}().Put(it.bodyAsClass({1}PutRequest::class.java))) }}""".format(MODULE_NAME.lower(), MODULE_NAME)

if VERB.lower() in ("patch", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
Patch("/{0}") {{ it.json({1}().Patch(it.bodyAsClass({1}PatchRequest::class.java))) }}""".format(MODULE_NAME.lower(), MODULE_NAME)

if VERB.lower() in ("delete", "all"):
    ROUTE_CONTENT = ROUTE_CONTENT + """
Delete("/{0}") {{ it.json({1}().Delete(it.bodyAsClass({1}DeleteRequest::class.java))) }}""".format(MODULE_NAME.lower(), MODULE_NAME)


with open(MODEL_FILE, "a") as f:
    f.write(MODEL_CONTENT)
with open(MODULE_FILE, "a") as f:
    f.write(MODULE_CONTENT)
with open(ROUTE_FILE, "a") as f:
    f.write(ROUTE_CONTENT)

