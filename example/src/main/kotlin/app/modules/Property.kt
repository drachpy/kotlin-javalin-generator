package app.modules

import app.models.*

class Property {

    fun get(req: PropertyGetRequest) : PropertyGetResponse = PropertyGetResponse(id=req.id)

}
