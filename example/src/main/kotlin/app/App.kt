package app

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

        get("/property/:id") { it.json(Property().get(PropertyGetRequest(it.param("id").toString()))) }

    }
}
